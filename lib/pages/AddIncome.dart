import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MyText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';

class AddIncome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.textColor
        ),
        backgroundColor: MyColors.appBarColor,
        title: Row(
          children:[
            MyText('Add Income'),
          ],
        ),
      ),
    );
  }
}