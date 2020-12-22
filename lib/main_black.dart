import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncomes.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddExpense.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/pages/Incomes.dart';
import 'package:flutter_tutorial/pages/Balance.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';

/// this is the file in which i try dark theme with neon light

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
  DateTime lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
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
        ListOfIncomes.fromJson(jsonDecode(incN));
      });
      stateFunc();
    }
  }

  void stateFunc() {
    setState(() {
      income = filterOnPeriod(ListOfIncomes.list);
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
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.backGroundColor2,
        appBar: buildAppBar(),
        body: buildBody(),
      )
    );
  }

  Widget buildAppBar() {
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
          MainRowText('Finance'),
          buildDropdownButton(),
        ],
      ),
      centerTitle: true,
      backgroundColor: MyColors.mainColor,
    );
  }

  Widget buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          // date row
          _getData(),

          // income row
          Container(
            decoration: BoxDecoration(
                color: MyColors.rowColor,
                borderRadius: BorderRadius.all(Radius.circular(25)
                )
            ),
            height: size.height * 0.075,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Center(child: viewInfo(index: 'Incomes', category: income)),
          ),

          // expense row
          Container(
            decoration: BoxDecoration(
                color: MyColors.rowColor,
                borderRadius: BorderRadius.all(Radius.circular(25)
                )
            ),
            height: size.height * 0.075,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Center(child: viewInfo(index: 'Expenses', category: expense)),
          ),

          // balance row
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

          // low buttons to add notes
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
                  child: myFlatButton(index: 'Add Income', width: size.width/1.3),
                )
              ],
            ),
          ),
        ],
      );
  }

  myFlatButton({String index, double width = 200}){
    Color textColor;
    if (index == 'Add Expense')
      textColor = MyColors.expenseButton;
    if (index == 'Add Income')
      textColor = MyColors.incomeButton;
    return Container(
      height: 70,
      width: width,
      decoration: BoxDecoration(
          color: MyColors.backGroundColor2,
          //boxShadow: [BoxShadow(color: buttonColor, blurRadius: 10, spreadRadius: 1),],
          borderRadius: BorderRadius.all(Radius.circular(25),
          ),
          boxShadow: [BoxShadow(color: MyColors.blurColor, blurRadius: 15, spreadRadius: 5),]
      ),
      child: FlatButton(
          onPressed: () => _goTo(context, index),
          child: Text(index,style: TextStyle(color: textColor, fontSize: 20), )
      ),
    );
  }

  buildDropdownButton() {
    return DropdownButton(
        hint: MainRowText(selMode),
        items: [
          DropdownMenuItem(value: 'Day', child: MainRowText('Day')),
          DropdownMenuItem(value: 'Week', child: MainRowText('Week')),
          DropdownMenuItem(value: 'Month', child: MainRowText('Month')),
          DropdownMenuItem(value: 'Year', child: MainRowText('Year')),
        ],
        onChanged: (String newValue) {
          if (selMode == 'Day' && newValue != 'Day') {
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selMode == 'Week' && newValue != 'Week') {
            date = DateTime.now();
          }
          if (selMode == 'Month' && newValue != 'Month') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selMode == 'Year' && newValue != 'Year') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
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
                //boxShadow: [BoxShadow(color: MyColors.mainColor, blurRadius: 10, spreadRadius: 1),],
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: GestureDetector(
                child: MainRowText(index, TextAlign.left),
                onTap: () => _goTo(context, index)),
          ),
          MainRowText('$category', TextAlign.right),
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
      case 'Incomes':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Incomes(updateMainPage: stateFunc);
            }));
        break;
      case 'Expenses':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Expenses(updateMainPage: stateFunc);
            }));
        break;
    }
  }

  _isInFilter(DateTime d) {
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
          d.year == lastWeekDay.year &&
              //d.month == lastWeekDay.month &&
              d.isBefore(lastWeekDay) && d.isAfter(lastWeekDay.subtract(Duration(days: 7)));
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

  _getData(){
    switch(selMode){
      case 'Day':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = date.subtract(Duration(days: 1));
                  stateFunc();
                });

              },
            ),
            MainRowText(date.toString().substring(0, 10)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 1));
                  stateFunc();
                });

              },
            ),
          ],
        );
      case 'Week':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  lastWeekDay = lastWeekDay.subtract(Duration(days: 7));
                  stateFunc();
                });
              },
            ),
            Row(
              children: [
                MainRowText(lastWeekDay.subtract(Duration(days: 6)).toString().substring(0, 10) + ' - '),
                MainRowText(lastWeekDay.toString().substring(0, 10)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  lastWeekDay = lastWeekDay.add(Duration(days: 7));
                  stateFunc();
                });
              },
            ),
          ],
        );
      case 'Month':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = new DateTime(date.year, date.month - 1, date.day);
                  stateFunc();
                });
              },
            ),
            MainRowText(date.month.toString()),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year, date.month + 1, date.day);
                  stateFunc();
                });
              },
            ),
          ],
        );
      case 'Year':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = new DateTime(date.year - 1, date.month, date.day);
                  stateFunc();
                });
              },
            ),
            MainRowText(date.year.toString()),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year + 1, date.month, date.day);
                  stateFunc();
                });
              },
            ),
          ],
        );
    }
  }

}
