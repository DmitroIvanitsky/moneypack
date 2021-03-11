import 'package:flutter/material.dart';
import '../setting/AppColors.dart';

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
        color: AppColors.textColor(),
        fontSize: 15,
      ),
    );
  }
}