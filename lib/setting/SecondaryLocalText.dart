import 'package:flutter/material.dart';
import '../setting/AppColors.dart';
import '../Utility/appLocalizations.dart';

class SecondaryLocalText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  SecondaryLocalText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        AppLocalizations.of(context).translate(text),
        textAlign: align,
        style: TextStyle(
          color: color ?? AppColors.textColor(),
          fontSize: 17,
        ),
      ),
    );
  }
}