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
          //bottomNavigationBar: buildBottomAppBar(),
          appBar: AppBar(
              shadowColor: Colors.black,
              backgroundColor: MyColors.mainColor,
              title: Row(
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
              )
          ),
          body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.865,
                  child: calc
                ),
              ),
          ),
        ),
    );
  }

}


