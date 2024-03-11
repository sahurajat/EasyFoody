// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/user-model.dart';
import 'get-device-control-token.dart';

class SignUpController extends GetxController {
  //use the get device token controller to fetch the device token
  final DeviceTokenController getDeviceTokenController =
      Get.put(DeviceTokenController());
  //firts we have to create a auth variable of firebase instance  type

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//for password visibility

  var isPasswordVisible = false.obs;

  Future<UserCredential?> signupMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userLocality,
    String userPassword,
    String userDeviceToken,
  ) async {
    try {
      //for loading operation(start)

      EasyLoading.show(status: "Please wait ...");

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      //for sending a email to the user for verification

      await userCredential.user!
          .sendEmailVerification(); //(the user is not null)

      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now(),
          city: userLocality);

      //now we have to add the data into firestore(database)

      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      //we have to stop the loading option here

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
