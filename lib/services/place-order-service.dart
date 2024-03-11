// ignore_for_file: file_names, unused_local_variable, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/models/order-model.dart';
import 'package:easyfoody/screens/user-pannel/main-screen.dart';
import 'package:easyfoody/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'generate-order-id-service.dart';

void placeOrder(
    {required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerAdress,
    required String customerDeviceToken}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please Wait");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      //for place the order
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel orderModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],

          //addd the extra details
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAdress,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAdress': customerAdress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'CreatedAt': DateTime.now()
            },
          );

          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(orderModel.toMap());

          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete()
              .then((value) {
            print("Delete cart Products $orderModel.productId.toString()");
          });
        }
      }

      print("Order confirmed");
      Get.snackbar("Order Confirmed", "Thank you for your Order",
          backgroundColor: AppConstatnt.appMainColor,
          duration: Duration(seconds: 5));
      EasyLoading.dismiss();
      Get.offAll(() => mainScreen());
    } catch (e) {
      print("error $e");
    }
  }
}
