import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget{
  final String text;
  final TextAlign align;
  Color color;

  SecondaryText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    if (color == null)
      color = Colors.black;
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 17,
      ),
    );
  }
}