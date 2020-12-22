import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';

class Calculator extends StatefulWidget {
  final Function updateSum;
  final double result;


  Calculator({this.updateSum, this.result});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  double _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
        value: _currentValue,
        hideExpression: false,
        hideSurroundingBorder: true,
        onChanged: (key, value, expression) {
          setState(() {
            _currentValue = value;
          });
        },
      theme: CalculatorThemeData(
        operatorColor: MyColors.mainColor,
        numColor: MyColors.backGroundColor,
        // displayColor: MyColors.backGroundColor,
        // expressionColor: MyColors.backGroundColor,
        commandColor: Colors.grey[500],
      ),
    );
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.mainColor,
             title: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 MainRowText('Calculator'),
                 IconButton(
                   iconSize: 35,
                   icon: Icon(Icons.done, color: MyColors.textColor),
                   onPressed: (){
                     Navigator.pop(context);
                     widget.updateSum(_currentValue);
                   },
                 )
               ],
             )
          ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: calc),
          ),
        ),
      ),
    );
  }
}


