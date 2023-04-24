import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import '../decorations/app_decorations.dart';
import '../Utility/app_localizations.dart';
import '../services/navigator_service.dart';
import '../widgets/main_row_text.dart';


class CalculatorPage extends StatefulWidget {
  final double initialAmount;
  final NavigatorService navigatorService;

  CalculatorPage({this.initialAmount, this.navigatorService});

  @override
  _CalculatorPageState createState() => _CalculatorPageState(initialAmount);
}

class _CalculatorPageState extends State<CalculatorPage> {
  _CalculatorPageState(this._currentValue);

  double _currentValue;

  @override
  Widget build(BuildContext context) {

    final calc = SimpleCalculator(
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
        numColor: Theme.of(context).backgroundColor,
        numStyle: TextStyle(fontSize: 25, color: Theme.of(context).textTheme.displayLarge.color,),
        commandColor: Color.fromARGB(255, 98,106,108),
        commandStyle: TextStyle(fontSize: 25, color: Color(0xff32373d)),
        displayStyle: TextStyle(fontSize: 50, color: Theme.of(context).textTheme.displayLarge.color,),
        operatorStyle: TextStyle(fontSize: 25, color: Color(0xff32373d)),
      ),
    );

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainRowText(
                      text: AppLocalizations.of(context).translate('Calculator'),
                      fontWeight: FontWeight.bold
                  ),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.done,
                    ),
                    onPressed: (){
                      widget.navigatorService.navigateBack(context: context, returnValue: _currentValue);
                    },
                  )
                ],
              )
          ),
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              decoration: AppDecoration.boxDecoration(context),
              height: MediaQuery.of(context).size.height * 0.85,
              child: calc
            ),
          ),
        ),
      ),
    );
  }
}


