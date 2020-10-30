import 'package:flutter/material.dart';

class AddExpenses extends StatelessWidget{
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
          'Add Expenses',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children:[
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 100,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter category',
              ),
            ),
          ),
          Container(
            height: 100,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter sum',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

