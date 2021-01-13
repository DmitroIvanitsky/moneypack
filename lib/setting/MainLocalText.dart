import 'package:flutter/material.dart';
import '../Utility/appLocalizations.dart';

class MainLocalText extends StatelessWidget{
  final String text;
  final TextAlign align;
  final Color color;

  MainLocalText({this.text, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    Color _color;
    if (color == null) {
      _color = Colors.black;
    }else{
      _color = color;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        AppLocalizations.of(context).translate(text) == null? Text('NL::' +text) : AppLocalizations.of(context).translate(text),
        textAlign: align,
        style: TextStyle(
          color: _color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}