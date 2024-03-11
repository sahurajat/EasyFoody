// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, duplicate_ignore, non_constant_identifier_names, avoid_types_as_parameter_names, unused_local_variable, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/screens/user-pannel/get-customer-device-token.dart';
import 'package:easyfoody/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../controllers/cart-price-controller.dart';
import '../../models/cart-model.dart';
import '../../services/place-order-service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<CheckoutScreen> {
  //to fetch the user id
  User? user = FirebaseAuth.instance.currentUser;
  //first we have to  call the cart-price-controller to calculate the product total price
  final ProductPriceController pdctpriceController =
      Get.put(ProductPriceController());

  //now we have to create text editing controller for place order
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstatnt.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Checkout Screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppConstatnt.aStatusBarColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
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
                  CartModel cartModel = CartModel(
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
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                  );

                  //calculate price
                  pdctpriceController.fetchProductprice();
                  //
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe:
                            true, //(if we drag it it to full then the item will be deleted)
                        onTap: (CompletionHandler handler) async {
                          print('Deleted');
                          //this is a small query to  delte the item from the cart
                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 2,
                      color: AppConstatnt.aTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstatnt.appMainColor,
                          backgroundImage:
                              NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                          ],
                        ),
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //obx() are used to calculate the real time product price addition
            Obx(
              () => Text(
                "Total : ${pdctpriceController.totalPrice.value.toStringAsFixed(1)} ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: AppConstatnt.appMainColor,
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstatnt.bottomColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Confirm Order",
                      style: TextStyle(color: AppConstatnt.bottomTextColor),
                    ),
                    onPressed: () {
                      showCustomBottonSheet();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottonSheet() {
    Get.bottomSheet(
        Container(
          height: Get.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //this is for name
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      //we have to pass the controller
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                //for phone no
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      //we have to pass the controller
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone no',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                //for adress
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      //we have to pass the controller
                      controller: adressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                //now for confirmation of order we have create a button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstatnt.bottomColor,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                      onPressed: () async {
                        if (nameController.text != '' &&
                            phoneController.text != '' &&
                            adressController.text != '') {
                          String name = nameController.text.trim();
                          String phone = phoneController.text.trim();
                          String address = adressController.text.trim();

                          //if the name,phone,adress     are not empty then it take the customer token
                          String customerToken = await getCustomerDeviceToken();

                          //place orrder service
                          placeOrder(
                              context: context,
                              customerName: name,
                              customerPhone: phone,
                              customerAdress: address,
                              customerDeviceToken: customerToken);
                        } else {
                          print("Please fill all Details");
                        }
                      },
                      child: Text(
                        "Place Order",
                        style: TextStyle(
                            color: AppConstatnt.bottomTextColor, fontSize: 20),
                      )),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        elevation: 6);
  }
}
