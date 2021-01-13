import 'package:flutter/material.dart';

class MainRowText extends StatelessWidget{
  final String text;
  final TextAlign align;
  Color color;

  MainRowText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    if (color == null)
      color = Colors.black;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}