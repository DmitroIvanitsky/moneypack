import 'package:flutter/material.dart';

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
        color: Theme.of(context).textTheme.displaySmall.color,
        fontSize: Theme.of(context).textTheme.displaySmall.fontSize,
      ),
    );
  }
}


