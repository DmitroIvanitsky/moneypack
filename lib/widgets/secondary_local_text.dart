import 'package:flutter/material.dart';
import '../Utility/app_localizations.dart';

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
          color: color ?? Theme.of(context).textTheme.displayMedium.color,
          fontSize: Theme.of(context).textTheme.displayMedium.fontSize,
        ),
      ),
    );
  }
}