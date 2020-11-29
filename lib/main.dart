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
  double expense = 0;
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
      expense = ListOfExpenses.sum();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
        body: buildListView(),
      ),
    );
  }

  buildListView(){
    return ListView(
      children: [
        Column(
          children: [
/////////// Buttons on the first row ///////////////////////////////////////////
            Container(
              color: MyColors.backGroundColor,
              margin: EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  myFlatButton(period: 'Day'),
                  myFlatButton(period: 'Week'),
                  myFlatButton(period: 'Month'),
                ],
              ),
            ),
/////////// Income /////////////////////////////////////////////////////////////
            Row(
              children: [
                // category
                Container(
                  width: 320,
                  height: 50,
                  margin: margin(),
                  color: MyColors.rowColor,
                  child: Center(
                    child: viewInfo(period: 'Income', category: income),
                  ),
                ),
                // button
                Container(
                  margin: EdgeInsets.only(top: 20),
                  color: MyColors.rowColor,
                  width: 70,
                  height: 50,
                  child: button(
                      index: 'AddIncome',
                      icon: Icon(Icons.add_circle)
                  ),
                ),
              ]
            ),
/////////// Expenses ///////////////////////////////////////////////////////////
            Row(
              children: [
                // category
                Container(
                  color: MyColors.rowColor,
                  width: 320,
                  height: 110,
                  margin: margin(),
                  child: Column(
                    children: [
                      // Day Row
                      viewInfo(period: 'Expense', category: expense),
                      // Week Row
                      //viewInfo(period: 'Week', per: week),
                      // Month Row
                      //viewInfo(period: 'Month', per: month),
                    ],
                  ),
                ),
                // button
                Container(
                  color: MyColors.rowColor,
                  margin: EdgeInsets.only(top: 20),
                  width: 70,
                  height: 110,
                  child: button(
                      index: 'AddExpenses',
                      icon: Icon(Icons.add_circle)
                  ),
                ),
              ],
            ),
/////////// Balance ////////////////////////////////////////////////////////////
            Row(
              children: [
                // category
                Container(
                  width: 320,
                  height: 50,
                  margin: margin(),
                  color: MyColors.rowColor,
                  child: Center(
                    child: viewInfo(period: 'Balance', category: balance),
                  ),
                ),
                // button
                Container(
                  margin: EdgeInsets.only(top: 20),
                  color: MyColors.rowColor,
                  width: 70,
                  height: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: button(
                        index: 'ShowBalance',
                        icon: Icon(Menu_icon.kebab_vertical)
                    ),
                  ),
                ),
              ],
            ),
/////////// Low buttons Expenses and Income ////////////////////////////////////
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
/////////// Add Expense button /////////////////////////////////////////////////

          ],
        ),
      ]
    );
  }
//////////// Functions /////////////////////////////////////////////////////////
  myFlatButton({String period}){
    return FlatButton(
      color: MyColors.mainColor,
      height: 50,
      onPressed: () {},
      child: MyText(period)
    );
  }

  margin(){
    return EdgeInsets.only(left: 10, top: 20);
  }

  button({String index, Icon icon}){
    return IconButton(
      iconSize: 35,
      onPressed: () => _goTo(context, index),
      icon: Container(
        child: icon,
      ),
    );
  }

  viewInfo({String period, double category}){
    double top = 10;
    if (period == 'Income' || period == "Balance")
      top = 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10, top: top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(period, TextAlign.left),
          MyText('$category', TextAlign.right),
        ],
      ),
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
      backgroundColor: MyColors.mainColor,
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
//////////// Functions /////////////////////////////////////////////////////////
}
