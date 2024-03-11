// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_print, prefer_const_declarations, deprecated_member_use, duplicate_ignore

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/models/product-model.dart';
import 'package:easyfoody/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cart-model.dart';
import 'cart-screen.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  //to fetch the user id from the  firebase
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstatnt.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Product Detail",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppConstatnt.aStatusBarColor,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => cartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: Container(
        color: AppConstatnt.appMainColor,
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 60,
            ),
            //now we have to show the product images
            CarouselSlider(
              //to fetch the product image from the database
              items: widget.productModel.productImages
                  .map(
                    (imageUrl) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: Get.width - 10,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: AppConstatnt.categoriesColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productModel.productName,
                            ),
                            Icon(Icons.favorite_border_outlined)
                          ],
                        ),
                      ),
                    ),
                    //for showing the category name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            widget.productModel.isSale == true &&
                                    widget.productModel.salePrice != ""
                                ? Text(
                                    "RS: " + widget.productModel.salePrice,
                                  )
                                : Text(
                                    "RS: " + widget.productModel.fullPrice,
                                  )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Category: " + widget.productModel.categoryName,
                        ),
                      ),
                    ),
                    //for showing its description
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.productModel.productDescription,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 16,
                    ),
                    //now we have o add a button
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //this for add to cart option
                            Material(
                              color: AppConstatnt.categoriesColor,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstatnt.bottomColor,
                                    borderRadius: BorderRadius.circular(40)),
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                child: TextButton(
                                    onPressed: () {
                                      sendMessageonWhatsapp(
                                        productmodel: widget.productModel,
                                      );
                                    },
                                    child: Text(
                                      "whatsapp",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppConstatnt.bottomTextColor),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            //this is for whtsap option
                            Material(
                              color: AppConstatnt.categoriesColor,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppConstatnt.bottomColor,
                                    borderRadius: BorderRadius.circular(40)),
                                width: Get.width / 3.0,
                                height: Get.height / 16,
                                child: TextButton(
                                    onPressed: () async {
                                      await checkProductExistance(
                                          uId: user!.uid);
                                    },
                                    child: Text(
                                      "Add to cart",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppConstatnt.bottomTextColor),
                                    )),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> sendMessageonWhatsapp(
      {required ProductModel productmodel}) async {
    final number = "917008026899";
    final message =
        "Hello Raju \n i wnat to know abut this product \n${productmodel.productImages}\n ${productmodel.productName}  \n ${productmodel.categoryName} \n${productmodel.productDescription}";

    //i have creteda url to pass the message
    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //create a method to check if the product is exist or not
  Future<void> checkProductExistance(
      {required String uId, int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();
    //if a product already in the cart  we increse the quantity and increase the price else we add the item in to the cart option
    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;

      //now  we have to update the price

      //if the product is in sale then take its salePrice otherwise take its full price
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });
      print("product exist");
    } else {
      //if product does not exist in the cart
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
      );
      await documentReference.set(cartModel.toMap());
      print("product added");
    }
  }
}
