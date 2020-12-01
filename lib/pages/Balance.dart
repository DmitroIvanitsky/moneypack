import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class ShowBalance extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyColors.textColor),
          backgroundColor: MyColors.mainColor,
          title: MyText('Balance'),
        ),
      ),
    );
  }
}