import 'package:flutter/material.dart';
import 'file:///C:/Users/nic-pc/Desktop/projects/flutter_tutorial/lib/setting/MyText.dart';
import 'file:///C:/Users/nic-pc/Desktop/projects/flutter_tutorial/lib/setting/MyColors.dart';

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