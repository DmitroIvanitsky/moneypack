import 'package:flutter/material.dart';
import 'package:money_pack/setting/MyColors.dart';

class SecondaryText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  SecondaryText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    Color _color;

    if (color == null)
      _color = MyColors.textColor2;
    else
      _color = color;

    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: _color,
        fontSize: 17,
      ),
    );
  }
}