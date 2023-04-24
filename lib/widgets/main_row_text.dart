import 'package:flutter/material.dart';

class MainRowText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  MainRowText({this.text, this.align, this.color, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
          fontSize: fontSize ?? 18,
          fontFamily: 'main',
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
    );
  }
}