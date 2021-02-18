import 'package:flutter/material.dart';
import 'package:money_pack/setting/MyColors.dart';

class ThirdText extends StatelessWidget{
  final String text;
  final TextAlign align;

  ThirdText(this.text, [this.align]);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: MyColors.textColor2,
        fontSize: 15,
      ),
    );
  }
}