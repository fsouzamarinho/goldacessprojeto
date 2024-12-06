import 'package:flutter/material.dart';
import 'package:goldsecurity/Style/colors.dart';


void showMessage ({String? message,
BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(
      message!,
      style:TextStyle(color: branco),
    ),
    backgroundColor: primaryColor));
}