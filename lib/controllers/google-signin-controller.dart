// ignore_for_file: avoid_print, unused_field, unused_local_variable, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user-model.dart';
import '../screens/user-pannel/main-screen.dart';
import 'get-device-control-token.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    //use the get device token controller to fetch the device token
    final DeviceTokenController getDeviceTokenController =
        Get.put(DeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        //now we add the loading option when we select the googleAccount
        EasyLoading.show(status: "Please wait ...");
        //now check if signin acccount is null or not
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          //now here there are two string are required one is idToken and another is accessToken
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        //now for store the user who are sign in in the app
        final User? user = userCredential.user;

        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: getDeviceTokenController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              //for multi dashboard admin
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
              city: '');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
          //after sign in the easy loading will be finish so
          EasyLoading.dismiss();

          //after that i have to send this screen to
          Get.offAll(() => const mainScreen());
        }
      }
    } catch (e) {
      //in error also we dismiss easyloading bcz if in some error case will ocur then it will not show anything
      EasyLoading.dismiss();
      // Print the error message
      print("Error during sign-in: $e");
    }
  }
}
