// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/google-signin-controller.dart';
import '../../utils/app-constant.dart';
import 'sign-in-screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  //now we have to add the google signin controller in the welcome screen
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(
      //     "welcome to my app",
      //     style: TextStyle(
      //         color: const Color.fromARGB(255, 8, 8, 8),
      //         fontSize: 35,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: Container(
        color: AppConstatnt.appMainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height / 10,
            ),
            Container(child: Lottie.asset('assets/images/p3.json')),
            Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Happy Shopping",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: Get.height / 12,
            ),
            Material(
              color: AppConstatnt.appMainColor,
              child: Container(
                decoration: BoxDecoration(
                    color: AppConstatnt.bottomColor,
                    borderRadius: BorderRadius.circular(40)),
                width: Get.width / 1.2,
                height: Get.height / 12,
                child: TextButton.icon(
                    onPressed: () {
                      _googleSignInController.signInWithGoogle();
                    },
                    icon: Image.asset(
                      'assets/images/google.png',
                    ),
                    label: Text(
                      "Sign in with google",
                      style: TextStyle(
                          fontSize: 20, color: AppConstatnt.bottomTextColor),
                    )),
              ),
            ),
            SizedBox(
              height: Get.height / 32,
            ),
            Material(
              color: AppConstatnt.appMainColor,
              child: Container(
                decoration: BoxDecoration(
                    color: AppConstatnt.bottomColor,
                    borderRadius: BorderRadius.circular(40)),
                width: Get.width / 1.2,
                height: Get.height / 12,
                child: TextButton.icon(
                    onPressed: () {
                      Get.to(() => SigninPage());
                    },
                    icon: Image.asset('assets/images/gmail.png'),
                    label: Text(
                      "Sign in with Email",
                      style: TextStyle(
                          fontSize: 20, color: AppConstatnt.bottomTextColor),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
