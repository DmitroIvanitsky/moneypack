import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/pages/ShowBalance.dart';
import 'package:flutter_tutorial/pages/AddExpenses.dart';
import 'package:flutter_tutorial/pages/Income.dart';
import 'package:flutter_tutorial/setting/in__out_icons.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterTutorialApp(),
    )
);

class FlutterTutorialApp extends StatefulWidget {

  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {

  double day = 0;
  final double week = 20.0;
  final double month = 30.0;
  double income = 0;
  double balance = 0;

  void s(){
    setState(() {
      day = ListOfExpenses.sum();
      income = ListOfIncome.sum();
      balance = ListOfIncome.sum() - ListOfExpenses.sum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: MyColors.backGroudColor,
        appBar: AppBar(
          title: Row(
            children:[
              IconButton(
                color: Colors.black,
                onPressed: () => print('press'),
                icon: Icon(Icons.list),
              ),
              SizedBox(
                width: 100,
              ),
              Text(
              'FINANCE',
              style: TextStyle(
                color: Colors.black,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: MyColors.appBarColor,
        ),
        body: Column(
          children: [
            // Container of Day Week Month Expenses mapping
            Row(
              children: [
                Container(
                  width: 295,
                  height: 110,
                  margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  color: MyColors.rowColor,
                  child: Column(
                    children: [
                      // Day Row
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText('day', TextAlign.left),
                              MyText('$day', TextAlign.right),
                            ],
                          ),
                      ),
                      // Week Row
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText('Week', TextAlign.left),
                              MyText('$week', TextAlign.right),
                            ],
                          ),
                      ),
                      // Month Row
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText('Month', TextAlign.left),
                              MyText('$month', TextAlign.right),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                // Button
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  color: MyColors.rowColor,
                  width: 95,
                  height: 110,
                  //alignment: Alignment.centerRight,
                  //padding: EdgeInsets.fromLTRB(0, 0, 20, 50),
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () => _goTo(context, 'AddExpenses'),
                    icon: Container(
                      width: 15,
                      // decoration: BoxDecoration(
                      //   color: Colors.red,
                      //   borderRadius: BorderRadius.circular(100)
                      // ),
                      child: Icon(
                          Icons.add_circle
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Container of Income
            Row(
              children: [
                Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  color: MyColors.rowColor,
                  child: Center(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            MyText('Income', TextAlign.left),
                            MyText('$income', TextAlign.right),
                          ],
                        ),
                    ),
                  ),
                ),
                Container(
                  color: MyColors.rowColor,
                  width: 90,
                  height: 50,
                  //alignment: Alignment.centerRight,
                  //padding: EdgeInsets.fromLTRB(0, 0, 20, 50),
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () => _goTo(context, 'AddIncome'),
                    icon: Container(
                      width: 20,
                      // decoration: BoxDecoration(
                      //   color: Colors.green,
                      //   borderRadius: BorderRadius.circular(100)
                      // ),
                      child: Icon(
                          Icons.add_circle
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Container of Balance
            Row(
              children: [
                Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  color: MyColors.rowColor,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText('Balance', TextAlign.left),
                          MyText('$balance', TextAlign.right),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: MyColors.rowColor,
                  width: 90,
                  height: 50,
                  //alignment: Alignment.centerRight,
                  //padding: EdgeInsets.fromLTRB(0, 0, 20, 50),
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () => _goTo(context, 'ShowBalance'),
                    icon: Container(
                      width: 20,
                      // decoration: BoxDecoration(
                      //   color: Colors.purple,
                      //   borderRadius: BorderRadius.circular(100)
                      // ),
                      child: Icon(
                          Icons.apps
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Low buttons Expenses and Income
            Row(
              children: [
                // Expenses button
                Container(
                  width: 230,
                  height: 250,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 45,
                        left: 10,
                        child: IconButton(
                          color: MyColors.textColor,
                          iconSize: 100,
                          icon: Icon(In_Out.png_transparent_computer_icons_money_expense_cost_finance_others_miscellaneous_saving_service),
                          onPressed: () => _goTo(context, 'Expenses'),
                        ),
                      ),
                      Positioned(
                        bottom: 35,
                          left: 65,
                          child: MyText('expenses'),
                      ),
                    ],
                  ),
                ),
                // Income button
                Container(
                  height: 250,
                  width: 150,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 45,
                        child: IconButton(
                          color: MyColors.textColor,
                          iconSize: 100,
                          icon: Icon(In_Out.bagofmoney_dollar_4399),
                          onPressed: () => _goTo(context, 'Income'),
                        ),
                      ),
                      Positioned(
                        bottom: 35,
                          left: 25,
                          child: MyText('income'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  _goTo(BuildContext context, String index){
    switch(index){
      case 'AddExpenses': Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context){
                return AddExpenses(callBack: s);
              }
          )
      );
      break;
      case 'AddIncome': Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context){
                return AddIncome(callback: s);
              }
          )
      );
      break;
      case 'ShowBalance': Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context){
                return ShowBalance();
              }
          )
      );
      break;
      case 'Income': Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context){
                return Income(callback: s);
              }
          )
      );
      break;
      case 'Expenses': Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context){
                return Expenses(callback: s);
              }
          )
      );
      break;
    }
  }
}





