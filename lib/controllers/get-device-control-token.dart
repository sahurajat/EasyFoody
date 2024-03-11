// ignore_for_file: file_names, unnecessary_overrides, prefer_const_constructors, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceTokenController extends GetxController {
  String? deviceToken; //device token may be null

  @override
  void onInit() {
    //onInit() is similar to init() method it use to directlly fetch th e device token
    super.onInit();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    try {
      //take the user device token from the firebase
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        deviceToken = token;
        // print("token : $deviceToken");//for show the device token in the terminal
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 45, 93, 53),
          colorText: const Color.fromARGB(255, 46, 46, 45));
    }
  }
}
