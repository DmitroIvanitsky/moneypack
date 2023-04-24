import 'package:flutter/material.dart';

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
        color: color ?? Theme.of(context).textTheme.displayMedium.color,
        fontSize: Theme.of(context).textTheme.displayMedium.fontSize,
      ),
    );
  }
}