import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddExpenses.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/pages/Income.dart';
import 'package:flutter_tutorial/pages/ShowBalance.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: true,
  home: FlutterTutorialApp(),
));


class FlutterTutorialApp extends StatefulWidget {
  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {
  DateTime date = DateTime.now();
  DateTime oldDate;
  String selMode = 'Day';
  double income = 0;
  double expense = 0;
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
      income = filterOnPeriod(ListOfIncome.list);
      expense = filterOnPeriod(ListOfExpenses.list);
      balance = income - expense;
    });
  }

  double filterOnPeriod(List list){
    double v = 0;
    for (int i = 0; i < list.length; i++) {
      if (_isInFilter(list[i].date)) {
        v += list[i].sum;
      }
    }
    return v;
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: MyColors.rowColor,
                    borderRadius: BorderRadius.all(Radius.circular(25)
                    )
                ),
                height: size.height * 0.075,
                margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Center(child: viewInfo(index: 'Income', category: income)),
              ),

              Container(
                decoration: BoxDecoration(
                    color: MyColors.rowColor,
                    borderRadius: BorderRadius.all(Radius.circular(25)
                    )
                ),
                height: size.height * 0.075,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Center(child: viewInfo(index: 'Expense', category: expense)),
              ),

//            Column(
//              children: [
              Container(
                decoration: BoxDecoration(
                    color: MyColors.rowColor,
                    borderRadius: BorderRadius.all(Radius.circular(25)
                    )
                ),
                height: size.height * 0.075,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Center(child: viewInfo(index: 'Balance', category: balance)),
              ),
              //////// low buttons to add notes
              Container(
                //height: size.height * 0.35,
                //color: Colors.yellow,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: myFlatButton(index: 'Add Expense', width: size.width/1.3),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 15),
                      child: myFlatButton(index: 'Add Income', width: size.width/1.3),)
                  ],
                ),
              ),
//              ],
//            ),
            ],
          ),
        )
    );
  }

  myFlatButton({String index, double width = 200}){
    Color buttonColor;
    if (index == 'Add Expense')
      buttonColor = MyColors.expenseButton;
    if (index == 'Add Income')
      buttonColor = MyColors.incomeButton;
    return Container(
      height: 70,
      width: width,
      decoration: BoxDecoration(
          color: buttonColor,
          //boxShadow: [BoxShadow(color: buttonColor, blurRadius: 10, spreadRadius: 1),],
          borderRadius: BorderRadius.all(Radius.circular(25),
          )
      ),
      child: FlatButton(
          onPressed: () => _goTo(context, index),
          child: MyText(index)
      ),
    );
  }

  buildDropdownButton() {
    return DropdownButton(
        hint: MyText(selMode),
        items: [
          DropdownMenuItem(value: 'Day', child: MyText('Day')),
          DropdownMenuItem(value: 'Week', child: MyText('Week')),
          DropdownMenuItem(value: 'Month', child: MyText('Month')),
          DropdownMenuItem(value: 'Year', child: MyText('Year')),
        ],
        onChanged: (String newValue) {
          if (selMode != 'Week' && newValue == 'Week') {
            // oldDate = date;
            date = date.subtract(Duration(days: date.weekday + 1)).add(Duration(days: 7));
          }

          if (selMode == 'Week' && newValue != 'Week' && oldDate != null) {
            //date = oldDate;
            date = DateTime.now();
          }

          setState(() {
            selMode = newValue;
          });
          stateFunc();


        }
    );
  }

  viewInfo({String index, double category}){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            height: size.height * 0.075,
            width: size.width * 0.35,
            decoration: BoxDecoration(
                color: MyColors.mainColor,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: GestureDetector(
                child: MyText(index, TextAlign.left),
                onTap: () => _goTo(context, index)),
          ),
          MyText('$category', TextAlign.right),
        ],
      ),
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

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            color: Colors.black,
            onPressed: () => print('press'),
            icon: Icon(Icons.list),
          ),
          // SizS
          Text(
            'FINANCE',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          buildDropdownButton(),
        ],
      ),
      centerTitle: true,
      backgroundColor: MyColors.mainColor,
    );
  }

  _isInFilter(DateTime d){
    if (d == null) return false;

    switch (selMode) {
      case 'Day' :
        return
          d.year == date.year &&
              d.month == date.month &&
              d.day == date.day;
        break;
      case 'Week':
        return
          d.year == date.year &&
              d.month == date.month &&
              d.isBefore(date) && d.isAfter(date.subtract(Duration(days: 7)));
        break;
      case 'Month' :
        return
          d.year == date.year &&
              d.month == date.month;
        break;
      case 'Year' :
        return
          d.year == date.year;
        break;
    }
  }

}
