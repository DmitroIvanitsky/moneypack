import 'package:flutter/material.dart';
import '../setting/MyColors.dart';

class MainRowText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  MainRowText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    Color _color;
    if (color == null)
      _color = MyColors.textColor2;
    else
      _color = color;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: _color,
          fontSize: 18,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}