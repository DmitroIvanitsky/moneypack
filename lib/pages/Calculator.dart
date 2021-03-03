import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:money_pack/Utility/Storage.dart';
import 'package:money_pack/setting/AppDecoration.dart';
import '../Utility/appLocalizations.dart';
import '../setting/MainRowText.dart';
import '../setting/AppColors.dart';


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
        operatorColor: Color.fromARGB(255, 98,106,108),
        numColor: AppColors.backGroundColor(),
        numStyle: TextStyle(fontSize: 25, color: AppColors.textColor()),
        commandColor: Color.fromARGB(255, 98,106,108),
        commandStyle: TextStyle(fontSize: 25, color: Color(0xff32373d)),
        displayStyle: TextStyle(fontSize: 50, color: AppColors.textColor()),
        operatorStyle: TextStyle(fontSize: 25, color: Color(0xff32373d)),
      ),
    );

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backGroundColor(),
          appBar: AppBar(
              shadowColor: AppColors.backGroundColor().withOpacity(.001),
              backgroundColor: AppColors.backGroundColor(),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainRowText(
                      text: AppLocalizations.of(context).translate('Калькулятор'),
                      fontWeight: FontWeight.bold
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.done, color: AppColors.textColor()),
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
                    decoration: AppDecoration.boxDecoration(context),
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


