// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class keyBoardUtill {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    //now we have to write a if else statement(if keyboard is open then close it)
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
