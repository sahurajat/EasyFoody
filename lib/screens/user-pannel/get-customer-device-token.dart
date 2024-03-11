// ignore_for_file: file_names, unused_local_variable, avoid_print
//to fetch the user token
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getCustomerDeviceToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token;
    } else {
      throw Exception("Error");
    }
  } catch (e) {
    print("Error $e");
    throw Exception("Error");
  }
}
