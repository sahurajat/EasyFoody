// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:easyfoody/screens/user-pannel/all-categories-screen.dart';
import 'package:easyfoody/screens/user-pannel/cart-screen.dart';
import 'package:easyfoody/widgets/category-widget.dart';
import 'package:easyfoody/widgets/flash-sale-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app-constant.dart';
import '../../widgets/all-products-widget.dart';
import '../../widgets/banner-widgets.dart';
import '../../widgets/custom-drawer-widget.dart';
import '../../widgets/heading-widget.dart';
import 'all-flash-screen.dart';
import 'all-products-screen.dart';

class mainScreen extends StatelessWidget {
  const mainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstatnt.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConstatnt.aStatusBarColor,
        title: Text(
          AppConstatnt.appmainName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: AppConstatnt.appMainColor,
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 90.0,
              ),
              //now we call the banners
              BAnnerWidget(),

              //this will help to create  multiple heading in a single page
              HeadingWidget(
                headingTitle: "Categories",
                headingSubtitle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See more >",
              ),
              CategoryWidget(),
              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubtitle: "According to your budget",
                onTap: () => Get.to(() => allFlashScreenCategories()),
                buttonText: "See more >",
              ),
              FlashsaleWidget(),
              HeadingWidget(
                headingTitle: "All Products",
                headingSubtitle: "According to your budget",
                onTap: () => Get.to(() => AllProductScreen()),
                buttonText: "See more >",
              ),

              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
