// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable, prefer_const_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../screens/auth-ui/sign-in-screen.dart';

class ForgotPasswordController extends GetxController {
  //firts we have to create a auth variable of firebase instance  type
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //in this case user credential is not required so we take it as void
  //Future<UserCredential?> ForgotPasswordMethod
  Future<void> ForgotPasswordMethod(
    String userEmail,
  ) async {
    try {
      //for loading operation(start)
      EasyLoading.show(status: "Please wait ...");

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
          "Request sent Sucessfully", "passsword reset link send to $userEmail",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 45, 93, 53),
          colorText: const Color.fromARGB(255, 46, 46, 45));
      Get.offAll(() => SigninPage());

      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 45, 93, 53),
          colorText: const Color.fromARGB(255, 46, 46, 45));
    }
  }
}
