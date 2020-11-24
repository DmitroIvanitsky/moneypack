import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/pages/ShowBalance.dart';
import 'package:flutter_tutorial/pages/AddExpenses.dart';
import 'package:flutter_tutorial/pages/Income.dart';
import 'package:flutter_tutorial/setting/in__out_icons.dart';
import 'package:flutter_tutorial/setting/MyText.dart';
import 'package:flutter_tutorial/setting/menu_icon.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterTutorialApp(),
    ));

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
  Size size;

  @override
  void initState() {
    loadList();
    super.initState();
  }

  void loadList() async {
    String expN = await Storage.getString('ExpenseNote');
    String incN = await Storage.getString('IncomeNote');
    if (expN != null && incN != null) {
      setState(() {
        ListOfExpenses.fromJson(jsonDecode(expN));
        ListOfIncome.fromJson(jsonDecode(incN));
      });
      stateFunc();
    }
  }

  void stateFunc() {
    setState(() {
      day = ListOfExpenses.sum();
      income = ListOfIncome.sum();
      balance = ListOfIncome.sum() - ListOfExpenses.sum();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      size = MediaQuery.of(context).size;
      print(size);
    }
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: buildAppBar(),
      body: buildListView(context),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            // row of Day Week Month Expenses mapping
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.rowColor,
                  ),
                  width: 320,
                  height: 110,
                  margin: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                  // color: MyColors.rowColor,
                  child: Column(
                    children: [
                      // Day Row
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText('Day', TextAlign.left),
                            MyText('$day', TextAlign.right),
                          ],
                        ),
                      ),
                      // Week Row
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
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
                        padding: EdgeInsets.all(10),
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
                // button
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.rowColor,

                  ),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  //color: Colors.yellow,
                  // color: MyColors.rowColor,
                  width: 70,
                  height: 110,
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () => _goTo(context, 'AddExpenses'),
                    icon: Container(
                      // width: 15,
                      child: Icon(Icons.add_circle),
                    ),
                  ),
                ),
              ],
            ),
            // Row of Income
            Row(
              children: [
                // text
                Container(
                  width: 320,
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
                          MyText('Income', TextAlign.left),
                          MyText('$income', TextAlign.right),
                        ],
                      ),
                    ),
                  ),
                ),
                // button
                Container(
                  //color: Colors.yellow,
                  color: MyColors.rowColor,
                  width: 70,
                  height: 50,
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () => _goTo(context, 'AddIncome'),
                    icon: Container(
                      child: Icon(Icons.add_circle),
                    ),
                  ),
                ),
              ],
            ),
            // Row of Balance
            Row(
              children: [
                // text
                Container(
                  width: 320,
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
                // button
                Container(
                  //color: Colors.yellow,
                  color: MyColors.rowColor,
                  width: 70,
                  height: 50,
                  //alignment: Alignment.centerRight,
                  //padding: EdgeInsets.fromLTRB(0, 0, 20, 50),
                  child: Align(
                    alignment: Alignment.center,
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
                          Menu_icon.kebab_vertical,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Low buttons Expenses and Income
            Padding(
              padding: EdgeInsets.only(top: 90),
              child: Row(
                children: [
                  // Expense button goTo Expense page
                  Container(
                    //color: Colors.yellow,
                    width: 205,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment(-0.9, 0),
                          child: IconButton(
                            color: MyColors.textColor,
                            iconSize: 100,
                            icon: Icon(In_Out.cons_money_expense),
                            onPressed: () => _goTo(context, 'Expenses'),
                          ),
                        ),
                        MyText('expenses')
                      ],
                    ),
                  ),
                  // Income button goTo Income page
                  Container(
                    //color: Colors.green,
                    width: 205,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: MyColors.textColor,
                          iconSize: 100,
                          icon: Icon(In_Out.bagofmoney_dollar_4399),
                          onPressed: () => _goTo(context, 'Income'),
                        ),
                        MyText('income'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            color: Colors.black,
            onPressed: () => print('press'),
            icon: Icon(Icons.list),
          ),
          SizedBox(
            width: size.width * 0.243,
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
    );
  }

  _goTo(BuildContext context, String index) {
    switch (index) {
      case 'AddExpenses':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return AddExpenses(callBack: stateFunc);
        }));
        break;
      case 'AddIncome':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return AddIncome(callback: stateFunc);
        }));
        break;
      case 'ShowBalance':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return ShowBalance();
        }));
        break;
      case 'Income':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return Income(callback: stateFunc);
        }));
        break;
      case 'Expenses':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return Expenses(callback: stateFunc);
        }));
        break;
    }
  }
}
