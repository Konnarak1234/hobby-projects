import 'package:flutter/material.dart';
import 'package:gallery_hub_mobile_flutter/screens/login.dart';

final theme = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 14,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1)
    ),
    // errorBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.red, width: 1)
    // ),
  )
);
void main() {
  return runApp(MaterialApp(
    theme: theme,
    home: LoginScreen(),
  ));
}

