import 'package:flutter/material.dart';

class Income extends StatelessWidget{
  final Color appBarColor = Colors.amber[700];
  final Color backGroudColor = Colors.brown[50];
  final Color rowColor = Colors.brown[100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroudColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: appBarColor,
        title: Text(
          'Income',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}