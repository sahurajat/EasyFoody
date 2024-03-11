// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/get-user-data-controller.dart';
import '../../controllers/signin-controller.dart';
import '../../utils/app-constant.dart';
import '../admin-panel/admin-main-screen.dart';
import '../user-pannel/main-screen.dart';
import 'forgot-pass-screen.dart';
import 'sign-up-screen.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final SignInController signInController = Get.put(SignInController());
  //use uet user data controller for fetch the user data
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
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
            'Sign In',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                isKeyboardVisible
                    ? Text(
                        "Welcome to my app",
                        style: TextStyle(
                            color: AppConstatnt.SignInScreenTextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )
                    : Column(
                        children: [Lottie.asset('assets/images/signin.json')],
                      ),
                SizedBox(
                  height: Get.height / 70.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: userEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                        // Set filled to true to fill the background color
                        filled: true,
                        // Set fillColor to the desired background color
                        fillColor: AppConstatnt.textfieldFilledcolor,
                        // Define the border color and width
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 25, 15, 15)),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),

                        //perform operation on Textfromfield
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            obscureText:
                                signInController.isPasswordVisible.value,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    signInController.isPasswordVisible.toggle();
                                  },
                                  child:
                                      signInController.isPasswordVisible.value
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility)),
                              prefixIcon: Icon(Icons.password),
                              contentPadding:
                                  EdgeInsets.only(top: 2.0, left: 8.0),
                              filled: true, // Fill the background color
                              fillColor: AppConstatnt.textfieldFilledcolor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstatnt.textfieldBordercolor),
                              ),
                            ),
                          ),
                        ))),

                //now for forget password

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      //insted of get.offall we use  get.to() bcz we further return back to the sign in screen
                      Get.to(() => forgotPassScreen());
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          color: AppConstatnt.bottomColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
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
                          String password = userPassword.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            Get.snackbar("Error", "Please Enter all Details",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstatnt.appSecondaryColor,
                                colorText:
                                    const Color.fromARGB(255, 46, 46, 45));
                          } else {
                            UserCredential? userCredential =
                                await signInController.signinMethod(
                                    email, password);

                            if (userCredential != null) {
                              //in user credential we get the user id  so we fetch the user data here
                              var userData = await getUserDataController
                                  .getUserData(userCredential.user!.uid);

                              //now another condition that if user verify the email verification
                              if (userCredential.user!.emailVerified) {
                                //now check for the user is admin or not
                                if (userData[0]['isAdmin'] == true) {
                                  //we willl move into admin screen

                                  Get.snackbar("Sucess Admin Login",
                                      "Login Sucessfully ..",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Color.fromARGB(255, 45, 93, 53),
                                      colorText: const Color.fromARGB(
                                          255, 46, 46, 45));
                                  Get.off(() => AdminMainScreen());
                                } else {
                                  ///move into main screen for shopping

                                  Get.snackbar(
                                      "Sucess user login", "Login Sucessfully",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          AppConstatnt.appSecondaryColor,
                                      colorText: const Color.fromARGB(
                                          255, 46, 46, 45));
                                  Get.offAll(() => mainScreen());
                                }
                              } else {
                                Get.snackbar("Error",
                                    "Please verify your email before login",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstatnt.appSecondaryColor,
                                    colorText:
                                        const Color.fromARGB(255, 46, 46, 45));
                              }
                            } else {
                              Get.snackbar("Error", "Please Try again",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      AppConstatnt.appSecondaryColor,
                                  colorText:
                                      const Color.fromARGB(255, 46, 46, 45));
                            }
                          }
                        },
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                              fontSize: 20,
                              color: AppConstatnt.bottomTextColor),
                        )),
                  ),
                ),
                SizedBox(
                  height: Get.height / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: TextStyle(
                          fontSize: 15, color: AppConstatnt.bottomColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => SignUpPage()),
                      child: Text(
                        "Sign Up",
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
