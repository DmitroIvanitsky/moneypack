import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';

class ShowBalance extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: MyColors.textColor
        ),
        backgroundColor: MyColors.appBarColor,
        title: Text(
          'Show Balance',
          style: TextStyle(
            color: MyColors.textColor,
          ),
        ),
      ),
    );
  }
}