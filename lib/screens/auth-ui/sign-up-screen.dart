// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../controllers/signup-controller.dart';
import '../../utils/app-constant.dart';
import 'sign-in-screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SignUpPage> {
  //now we have to use the signup-contoller here
  final SignUpController signUpController = Get.put(SignUpController());

  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userLocality = TextEditingController();
  TextEditingController userPassword = TextEditingController();

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
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          //for  bouncing whole option
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Text(
                  "Welcome to my app",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),

                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      //perform operation on Textfromfield
                      child: TextFormField(
                        //we have to provide all the contoller of the input field
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
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      //perform operation on Textfromfield
                      child: TextFormField(
                        controller: userName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "UserName",
                            prefixIcon: Icon(Icons.person_3_rounded),
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
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      //perform operation on Textfromfield
                      child: TextFormField(
                        controller: userPhone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Phone",
                            prefixIcon: Icon(Icons.phone),
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
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),

                      //perform operation on Textfromfield
                      child: TextFormField(
                        controller: userLocality,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            hintText: "Locality",
                            prefixIcon: Icon(Icons.location_pin),
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
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),

                        //perform operation on Textfromfield
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            //this is for password visibility
                            obscureText:
                                signUpController.isPasswordVisible.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                filled: true,
                                // Set fillColor to the desired background color
                                fillColor: AppConstatnt.textfieldFilledcolor,
                                //for clickable  the image
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      signUpController.isPasswordVisible
                                          .toggle();
                                    },
                                    //when the password is visible it will show visibility icon and when password is not visible it will show visibility off option

                                    child:
                                        signUpController.isPasswordVisible.value
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                prefixIcon: Icon(Icons.password),
                                contentPadding:
                                    EdgeInsets.only(top: 2.0, left: 8.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 25, 15, 15)),
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ))),

                //now for forget sign up

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
                          String name = userName.text.trim();
                          String email = userEmail.text.trim();
                          String phone = userPhone.text.trim();
                          String local = userLocality.text.trim();
                          String pass = userPassword.text.trim();
                          String userDeviceToken = '';

                          if (name.isEmpty ||
                              email.isEmpty ||
                              phone.isEmpty ||
                              local.isEmpty ||
                              pass.isEmpty) {
                            Get.snackbar("Error", "Please Enter all Details",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstatnt.appSecondaryColor,
                                colorText:
                                    const Color.fromARGB(255, 46, 46, 45));
                          } else {
                            UserCredential? userCredential =
                                await signUpController.signupMethod(name, email,
                                    phone, local, pass, userDeviceToken);

                            if (userCredential != null) {
                              Get.snackbar("Veification Email sent.",
                                  "Please check your Email",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstatnt.appSecondaryColor,
                                  colorText:
                                      const Color.fromARGB(255, 46, 46, 45));

                              FirebaseAuth.instance.signOut();
                              //after verify the email it will move into signin page
                              Get.offAll(() => SigninPage());
                            }
                          }
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              fontSize: 20,
                              color: AppConstatnt.bottomTextColor),
                        )),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account .",
                      style: TextStyle(
                          fontSize: 15, color: AppConstatnt.bottomColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => SigninPage()),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstatnt.bottomColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
