// ignore_for_file: file_names, prefer_const_constructors, dead_code, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyfoody/models/categories-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../screens/user-pannel/allsingle-category-product-screen.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
              child: Text("No category found"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              height: Get.height / 5.5,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: snapshot.data!.docs[index]['categoryId'],
                        categoryImg: snapshot.data!.docs[index]
                            ['categoryImage'],
                        categoryName: snapshot.data!.docs[index]
                            ['categoryName']);
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => SingleCategoriesScreen(
                                categoryId: categoriesModel.categoryId,
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              child: FillImageCard(
                                borderRadius: 10.0,
                                width: Get.width / 4.0,
                                heightImage: Get.height / 12,
                                imageProvider: CachedNetworkImageProvider(
                                    categoriesModel.categoryImg),
                                title: Center(
                                  child: Text(
                                    categoriesModel.categoryName,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
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
