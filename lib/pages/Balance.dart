import 'package:flutter/material.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';

class ShowBalance extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
        iconTheme: IconThemeData(color: MyColors.textColor),
        backgroundColor: MyColors.mainColor,
        title: MainRowText('Баланс'),
      );
  }
}