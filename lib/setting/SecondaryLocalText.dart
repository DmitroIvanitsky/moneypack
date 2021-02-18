import 'package:flutter/material.dart';
import '../setting/MyColors.dart';
import '../Utility/appLocalizations.dart';

class SecondaryLocalText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  SecondaryLocalText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    Color _color;
    if (color == null) {
      _color = MyColors.textColor2;
    }else{
      _color = color;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        AppLocalizations.of(context).translate(text),
        textAlign: align,
        style: TextStyle(
          color: _color,
          fontSize: 17,
        ),
      ),
    );
  }
}