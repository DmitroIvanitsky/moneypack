import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import '../Utility/appLocalizations.dart';
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
          backgroundColor: MyColors.backGroundColor,
          appBar: AppBar(
              shadowColor: MyColors.backGroundColor.withOpacity(.001),
              backgroundColor: MyColors.backGroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainRowText(text: AppLocalizations.of(context).translate('Калькулятор')),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.done, color: MyColors.textColor2),
                    onPressed: (){
                      widget.updateSum(_currentValue);
                      Navigator.pop(context);
                    },
                  )
                ],
              )
          ),
          body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.backGroundColor,
                      boxShadow: MyColors.shadow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: calc
                  ),
                ),
              ),
          ),
        ),
    );
  }

}


