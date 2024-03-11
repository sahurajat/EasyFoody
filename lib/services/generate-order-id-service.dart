// ignore_for_file: unused_local_variable
//this program generate the unique id in every random seconds

import 'dart:math';

String generateOrderId() {
  DateTime now = DateTime.now();

  int randomNumbers = Random().nextInt(9999);
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers';

  return id;
}
