// ignore_for_file: file_names, prefer_const_constructors, dead_code, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/models/product-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-pannel/product-details-screen.dart';

class FlashsaleWidget extends StatelessWidget {
  const FlashsaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
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
              height: Get.height / 4.5,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
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
                      deliveryTime: productData['deliveryTime'],
                      isSale: productData['isSale'],
                      productDescription: productData['productDescription'],
                    );
                    // CategoriesModel categoriesModel = CategoriesModel(
                    //     categoryId: snapshot.data!.docs[index]['categoryId'],
                    //     categoryImg: snapshot.data!.docs[index]
                    //         ['categoryImage'],
                    //     categoryName: snapshot.data!.docs[index]
                    //         ['categoryName']);
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() =>
                              ProductDetailScreen(productModel: productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: FillImageCard(
                                borderRadius: 10.0,
                                width: Get.width / 3.5,
                                heightImage: Get.height / 12,
                                imageProvider: CachedNetworkImageProvider(
                                    productModel.productImages[0]),
                                title: Center(
                                  child: Text(
                                    productModel.categoryName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                footer: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rs: ${productModel.salePrice}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      " ${productModel.fullPrice}",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: const Color.fromARGB(
                                              255, 227, 65, 65),
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  })),
            );
          }
          return Container();
        });
  }
}
