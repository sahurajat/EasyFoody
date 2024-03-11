// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/auth-ui/welcome-screen.dart';
import '../screens/user-pannel/all-order-screen.dart';
import '../screens/user-pannel/all-products-screen.dart';
import '../screens/user-pannel/main-screen.dart';
import '../utils/app-constant.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    //as we are create a  side drawer widget so we don't return scaffold here

    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      //now n the child class we have to create a drawer

      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        //in drawer there will be a child
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Waris", style: TextStyle(color: Colors.white)),
                subtitle: Text("Version 1.0.1",
                    style: TextStyle(color: Colors.white)),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: AppConstatnt.appMainColor,
                  child: Text("W"),
                ),
              ),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 2.5,
              color: const Color.fromARGB(255, 67, 67, 67),
            ),
            //home
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Home", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => mainScreen());
                },
              ),
            ),
            //products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Products", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => AllProductScreen());
                },
              ),
            ),
            //shopping bag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Orders", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                onTap: () {
                  Get.back();
                  Get.to(() => allOrderScreen());
                },
              ),
            ),
            //Contact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Contact", style: TextStyle(color: Colors.white)),
                leading: Icon(
                  Icons.help_center,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
            //logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                //for peerforming logout operation
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut();

                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();

                  //now we return to the  welcome screen
                  Get.offAll(() => WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Logout", style: TextStyle(color: Colors.white)),

                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppConstatnt.appSecondaryColor,
      ),
    );
  }
}
