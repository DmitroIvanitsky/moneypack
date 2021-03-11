import 'package:flutter/material.dart';
import '../Utility/Storage.dart';


class AppColors{

  static Color mainColor = Color(0xffa6d2eb);

  static Color incomeButton = Color(0xffd2eba6);
  static Color expenseButton = Color(0xffeba6d2);

  static Color edit = Color(0xff69e85b);
  static Color delete = Colors.redAccent;

  static Color hintColor = Color.fromARGB(255, 98,106,108);

  static Color backGroundColor(){
    Color backGroundColor;
    if (Storage.brightness == Brightness.light)
      backGroundColor =  Colors.brown[50];
    if(Storage.brightness == Brightness.dark)
      backGroundColor = Color(0xff32373d);
    return backGroundColor;
  }

  static Color textColor(){
    Color textColor;
    if (Storage.brightness == Brightness.light)
      textColor =  Color.fromARGB(255, 98,106,108);
    if(Storage.brightness == Brightness.dark)
      textColor = Color(0xffafb7c3);
    return textColor;
  }

}
