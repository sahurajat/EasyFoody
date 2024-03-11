// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, duplicate_ignore, non_constant_identifier_names, avoid_types_as_parameter_names, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/models/order-model.dart';
import 'package:easyfoody/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart-price-controller.dart';

class allOrderScreen extends StatefulWidget {
  const allOrderScreen({super.key});

  @override
  State<allOrderScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<allOrderScreen> {
  //to fetch the user id
  User? user = FirebaseAuth.instance.currentUser;
  //first we have to  call the cart-price-controller to calculate the product total price
  final ProductPriceController pdctpriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstatnt.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "All Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppConstatnt.aStatusBarColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel(
                      productId: productData['productId'],
                      categoryId: productData['categoryId'],
                      productName: productData['productName'],
                      categoryName: productData['categoryName'],
                      salePrice: productData['salePrice'],
                      fullPrice: productData['fullPrice'],
                      productImages: productData['productImages'],
                      // productImages: productData['productImages'],
                      deliveryTime: productData['deliveryTime'],
                      isSale: productData['isSale'],
                      productDescription: productData['productDescription'],
                      productQuantity: productData['productQuantity'],
                      productTotalPrice: productData['productTotalPrice'],
                      createdAt: productData['createdAt'],
                      updatedAt: productData['updatedAt'],
                      customerId: productData['customerId'],
                      status: productData['status'],
                      customerName: productData['customerName'],
                      customerPhone: productData['customerPhone'],
                      customerAddress: productData['customerAddress'],
                      customerDeviceToken: productData['customerDeviceToken']);

                  //calculate price
                  pdctpriceController.fetchProductprice();
                  //
                  return Card(
                    elevation: 2,
                    color: AppConstatnt.categoriesColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstatnt.appMainColor,
                        backgroundImage:
                            NetworkImage(orderModel.productImages[0]),
                      ),
                      title: Text(orderModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(orderModel.productTotalPrice.toString()),
                          SizedBox(
                            width: 10.0,
                          ),
                          orderModel.status != true
                              ? Text(
                                  "Pending ...",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text(
                                  "Delivered ..",
                                  style: TextStyle(color: Colors.green),
                                )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
