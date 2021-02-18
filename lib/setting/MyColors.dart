import 'package:flutter/material.dart';

class MyColors{

  //static Color mainColor = Colors.lightBlue[200];
  //static Color mainColor = Color(0xff4cb3eb);
  static Color mainColor = Color(0xffa6d2eb);

  static Color expenseButton = Color(0xffeba6d2); // NIKA
  // static Color expenseButton = Color(0xffeaa6fb); // HTF
  //static Color expenseButton = Color(0xffeb834c);

  // static Color incomeButton = Color(0xff5be893);
  static Color incomeButton = Color(0xffd2eba6); // NIKA
  //static Color incomeButton = Color(0xff9bff99); //HTF

  static Color edit = Color(0xff69e85b);
  static Color delete = Colors.redAccent;
  static Color backGroundColor = Colors.brown[50];
  static Color rowColor = Colors.brown[100];
  static Color lightBrown = Color.fromARGB(255, 247, 245, 244);

  static Color buttonColor = Colors.black54;
  static Color secondTextColor = Colors.black54;
  static Color textColor = Colors.black;
  static Color textColor2 = Color.fromARGB(255, 98,106,108);

  static List<BoxShadow> shadow = [
    BoxShadow(
        color: Colors.white,
        offset: Offset(-7.5, -7.5),
        blurRadius: 10
    ),
    BoxShadow(
        color: Colors.brown[100],
        offset: Offset(7.5, 7.5),
        blurRadius: 10
    )
  ];

  static BoxDecoration boxDecoration = BoxDecoration(
    color: MyColors.backGroundColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: MyColors.shadow
  );
}
