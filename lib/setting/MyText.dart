import 'package:flutter/material.dart';

class MyText extends StatelessWidget{
  final String text;
  final TextAlign align;

  MyText(this.text, [this.align]);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}