import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

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
          //print("$key\t$value\t$expression");
        },
        onTappedDisplay: (value, details) {
          Navigator.pop(context);
          widget.updateSum(_currentValue);
        },
    );
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('SimpleCalculator'),
          // ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: calc),
          ),
        ),
      ),
    );
  }
}


