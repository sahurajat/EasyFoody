// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  //firts we have to create a auth variable of firebase instance  type
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//for password visibility
  var isPasswordVisible = false.obs;
  Future<UserCredential?> signinMethod(
    String userEmail,
    String userPassword,
  ) async {
    try {
      //for loading operation(start)
      EasyLoading.show(status: "Please wait ...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 45, 93, 53),
          colorText: const Color.fromARGB(255, 46, 46, 45));
    }
  }
}
