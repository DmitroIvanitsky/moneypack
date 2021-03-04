import 'package:flutter/material.dart';
import '../setting/AppColors.dart';

class SecondaryText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  SecondaryText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {

    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color ?? AppColors.textColor(),
        fontSize: 17,
      ),
    );
  }
}