// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../models/product-model.dart';
import '../../utils/app-constant.dart';
import 'product-details-screen.dart';

class allFlashScreenCategories extends StatefulWidget {
  const allFlashScreenCategories({super.key});

  @override
  State<allFlashScreenCategories> createState() =>
      _allFlashScreenCategoriesState();
}

class _allFlashScreenCategoriesState extends State<allFlashScreenCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstatnt.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: AppConstatnt.aStatusBarColor,
        title: Text(
          "All Flash Sale",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('products')
              .where('isSale', isEqualTo: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                child: Text("No Product found"),
              );
            }

            if (snapshot.data != null) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    childAspectRatio: 1.19),
                itemBuilder: ((context, index) {
                  final productData = snapshot.data!.docs[index];
                  ProductModel productModel = ProductModel(
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
                  );

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() =>
                            ProductDetailScreen(productModel: productModel)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: FillImageCard(
                              borderRadius: 10.0,
                              width: Get.width / 2.2,
                              heightImage: Get.height / 10,
                              imageProvider: CachedNetworkImageProvider(
                                  productModel.productImages[0]),
                              title: Center(
                                child: Text(
                                  productModel.categoryName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
                // return Container(
                //   height: Get.height / 5.5,
                //   child: ListView.builder(
                //       itemCount: snapshot.data!.docs.length,
                //       shrinkWrap: true,
                //       scrollDirection: Axis.horizontal,
                //       )),
                // );
              );
            }
            return Container();
          }),
    );
  }
}
