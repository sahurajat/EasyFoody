// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/forgot-password-controller.dart';
import '../../utils/app-constant.dart';

class forgotPassScreen extends StatefulWidget {
  const forgotPassScreen({super.key});

  @override
  State<forgotPassScreen> createState() => _SigninPageState();
}

class _SigninPageState extends State<forgotPassScreen> {
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: AppConstatnt.appMainColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AppConstatnt.aStatusBarColor,
          elevation: 0,
          title: Text(
            'Forgot Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 15,
                ),
                isKeyboardVisible
                    ? Text(
                        "Enter Valid Email",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    : Column(
                        children: [Lottie.asset('assets/images/forgot.json')],
                      ),
                SizedBox(
                  height: Get.height / 70.0,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      //perform operation on Textfromfield
                      child: TextFormField(
                        controller: userEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            filled: true,
                            // Set fillColor to the desired background color
                            fillColor: AppConstatnt.textfieldFilledcolor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 25, 15, 15)),
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    )),
                SizedBox(
                  height: Get.height / 20,
                ),
                Material(
                  color: AppConstatnt.appMainColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppConstatnt.bottomColor,
                        borderRadius: BorderRadius.circular(40)),
                    width: Get.width / 2,
                    height: Get.height / 18,
                    child: TextButton(
                        onPressed: () async {
                          String email = userEmail.text.trim();
                          //the trim() method are mainly used to remove the white space characters (spaces, tabs, newlines) from the word.

                          if (email.isEmpty) {
                            Get.snackbar("Error", "Please Enter all Details",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstatnt.appSecondaryColor,
                                colorText:
                                    const Color.fromARGB(255, 46, 46, 45));
                          } else {
                            String email = userEmail.text.trim();
                            forgotPasswordController.ForgotPasswordMethod(
                                email);
                          }
                        },
                        child: Text(
                          "Forget",
                          style: TextStyle(
                              fontSize: 20,
                              color: AppConstatnt.bottomTextColor),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
