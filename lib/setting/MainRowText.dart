import 'package:flutter/material.dart';
import '../setting/AppColors.dart';

class MainRowText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;
  final FontWeight fontWeight;

  MainRowText({this.text, this.align, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {

    Color _color;
    if (color == null)
      _color = AppColors.textColor();
    else
      _color = color;

    FontWeight _fontWeight;
    if (fontWeight == null)
      _fontWeight = FontWeight.normal;
    else
      _fontWeight = fontWeight;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: _color,
          fontSize: 18,
          fontFamily: 'main',
          fontWeight: _fontWeight,
        ),
      ),
    );
  }
}