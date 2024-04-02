// ignore_for_file: prefer_const_constructors, use_super_parameters, file_names, avoid_unnecessary_containers, unused_local_variable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/get-user-data-controller.dart';
import '../../utils/app-constant.dart';
import '../admin-panel/admin-main-screen.dart';
import '../user-pannel/main-screen.dart';
import 'welcome-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      moveMethod(context);
    });
  }

  Future<void> moveMethod(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      // Check the isAdmin option
      if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());
      } else {
        Get.offAll(() => mainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure Get is initialized before using Get.width
    Get.put(
        GetUserDataController()); // Initialize any GetX controller here if needed
    return Scaffold(
      backgroundColor: AppConstatnt.aStatusBarColor,
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: Get.width,
                  // Use MediaQuery instead of Get.width
                  alignment: Alignment.center,
                  child: Lottie.asset('assets/images/splash-icon.json'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: MediaQuery.of(context)
                    .size
                    .width, // Use MediaQuery instead of Get.width
                alignment: Alignment.center,
                child: Text(
                  AppConstatnt.apppoweredby,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 8, 8, 8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
