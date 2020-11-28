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
import 'package:flutter_tutorial/setting/MyText.dart';

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
//////////// Functions /////////////////////////////////////////////////////////
  buildListView(){
    return ListView(
      children: [
/////////// Income /////////////////////////////////////////////////////////////
        Container(
          width: 400,
          height: 50,
          margin: margin(),
          color: MyColors.rowColor,
          child: Center(child: viewInfo(index: 'Income', category: income)),
        ),
/////////// Expenses ///////////////////////////////////////////////////////////
        Container(
          color: MyColors.rowColor,
          width: 400,
          height: 50,
          margin: margin(),
          child: Center(child: viewInfo(index: 'Expense', category: expense)),
        ),
/////////// Balance ////////////////////////////////////////////////////////////
        Container(
          width: 400,
          height: 50,
          margin: margin(),
          color: MyColors.rowColor,
          child: Center(child: viewInfo(index: 'Balance', category: balance)),
        ),
//////// free space ////////////////////////////////////////////////////////////
        SizedBox(height: 375),
//////// low buttons to add notes
        Container(
          alignment: Alignment.bottomCenter,
          color: MyColors.backGroundColor,
          margin: EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myFlatButton(index: 'Add Expense'),
              myFlatButton(index: 'Add Income'),
            ],
          ),
        ),
      ]
    );
  }

  myFlatButton({String index}){
    return FlatButton(
        color: MyColors.appBarColor,
        height: 50,
        onPressed: () => _goTo(context, index),
        child: MyText(index)
    );
  }

  margin(){
    return EdgeInsets.only(left: 10, top: 20, right: 10);
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

  viewInfo({String index, double category}){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: MyText(index, TextAlign.left),
            onTap: () => _goTo(context, index)),
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
      backgroundColor: MyColors.appBarColor,
    );
  }

  _goTo(BuildContext context, String index) {
    switch (index) {
      case 'Add Expense':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddExpenses(callBack: stateFunc);
            }));
        break;
      case 'Add Income':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddIncome(callback: stateFunc);
            }));
        break;
      case 'Balance':
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
      case 'Expense':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Expenses(callback: stateFunc);
            }));
        break;
    }
  }

//////////// Functions /////////////////////////////////////////////////////////
}
