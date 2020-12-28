import 'package:flutter/material.dart';
import '../Utility/appLocalizations.dart';

class MainLocalText extends StatelessWidget{
  final String text;
  final TextAlign align;

  MainLocalText({this.text, this.align});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        AppLocalizations.of(context).translate(text) == null? Text('NL::' +text) : AppLocalizations.of(context).translate(text),
        textAlign: align,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}