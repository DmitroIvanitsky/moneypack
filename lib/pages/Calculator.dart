import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_tutorial/Utility/appLocalizations.dart';
import '../setting/MainLocalText.dart';
import '../setting/MainRowText.dart';
import '../setting/MyColors.dart';

class Calculator extends StatefulWidget {
  final Function (double) updateSum;
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
        commandColor: Colors.grey[500],
      ),
    );

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: buildBottomAppBar(),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: calc
                ),
                SizedBox(height: 2.5)
              ],
            ),
            ),
          ),
        ),
    );
  }

  Widget buildBottomAppBar() {
    return BottomAppBar(
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.mainColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5
            )
          ]
        ),
        height: 60,
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainRowText(text: AppLocalizations.of(context).translate('Калькулятор')),
              IconButton(
                iconSize: 35,
                icon: Icon(Icons.done, color: MyColors.textColor),
                onPressed: (){
                  widget.updateSum(_currentValue);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildAppBar() {
    return AppBar(
          backgroundColor: MyColors.mainColor,
           title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               MainLocalText(text: 'Calculator'),
               IconButton(
                 iconSize: 35,
                 icon: Icon(Icons.done, color: MyColors.textColor),
                 onPressed: (){
                   widget.updateSum(_currentValue);
                   Navigator.pop(context);
                 },
               )
             ],
           )
        );
  }
}


