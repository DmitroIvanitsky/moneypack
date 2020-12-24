import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget{
  final String text;
  final TextAlign align;

  SecondaryText({this.text, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
    );
  }
}