import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddExpense.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/pages/Incomes.dart';
import 'package:flutter_tutorial/pages/Balance.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';
import 'package:intl/intl.dart';
import 'Utility/appLocalizations.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: true,
  localizationsDelegates: [
    // A class which loads the translations from JSON files
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate
  ],
  supportedLocales: [
    const Locale.fromSubtags(languageCode: 'en'), // English, no country code
    const Locale.fromSubtags(languageCode: 'ru'),
    const Locale.fromSubtags(languageCode: 'ua'),
  ],
  home: FlutterTutorialApp(),
));

class FlutterTutorialApp extends StatefulWidget {
  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {
  DateTime date = DateTime.now();
  DateTime lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
  String selMode = 'День';
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
    setState(() {
      if (expN != null) ListOfExpenses.fromJson(jsonDecode(expN));
      if (incN != null) ListOfIncome.fromJson(jsonDecode(incN));
    });

    updateData();
  }

  void updateData() {
    setState(() {
      income = filterOnPeriod(ListOfIncome.list);
      expense = filterOnPeriod(ListOfExpenses.list);
      balance = balanceFunc();
    });
  }

  double balanceFunc(){
    return ListOfIncome.sum() - ListOfExpenses.sum();
  }

  double filterOnPeriod(List list){
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      if (_isInFilter(list[i].date)) {
        sum += list[i].sum;
      }
    }
    return sum;
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
        backgroundColor: MyColors.backGroundColor,
        drawer: buildDrawer(),
        appBar: buildAppBar(),
        body: buildBody(),
      )
    );
  }

  Widget buildDrawer(){
    return Drawer(
      child: Container(
        color: MyColors.backGroundColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MyText('Настройки'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MyText('Тема'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MyText('Язык'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.textColor),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText('Учёт'),
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
            child: Center(child: viewInfo(index: 'Доход', category: income)),
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
            child: Center(child: viewInfo(index: 'Расход', category: expense)),
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
            child: Center(child: viewInfo(index: 'Баланс общий', category: balance)),
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
                  child: myFlatButton(index: 'Добавить расход', width: size.width/1.3),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 15),
                  child: myFlatButton(index: 'Добавить доход', width: size.width/1.3),
                )
              ],
            ),
          ),
        ],
      );
  }

  myFlatButton({String index, double width = 200}){
    Color buttonColor;
    if (index == 'Добавить расход')
      buttonColor = MyColors.expenseButton;
    if (index == 'Добавить доход')
      buttonColor = MyColors.incomeButton;
    return Container(
      height: 70,
      width: 200,
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
          DropdownMenuItem(value: 'День', child: MyText('День')),
          DropdownMenuItem(value: 'Неделя', child: MyText('Неделя')),
          DropdownMenuItem(value: 'Месяц', child: MyText('Месяц')),
          DropdownMenuItem(value: 'Год', child: MyText('Год')),
        ],
        onChanged: (String newValue) {
          if (selMode == 'День' && newValue != 'День') {
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selMode == 'Неделя' && newValue != 'Неделя') {
            date = DateTime.now();
          }
          if (selMode == 'Месяц' && newValue != 'Месяц') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selMode == 'Год' && newValue != 'Год') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          setState(() {
            selMode = newValue;
          });
          updateData();
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
      case 'Добавить расход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddExpenses(callBack: updateData);
            }));
        break;
      case 'Добавить доход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddIncome(callback: updateData);
            }));
        break;
      case 'Баланс':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return ShowBalance();
            }));
        break;
      case 'Доход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Incomes(callback: updateData);
            }));
        break;
      case 'Расход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Expenses(callback: updateData);
            }));
        break;
    }
  }

  _isInFilter(DateTime d) {
    if (d == null) return false;

    switch (selMode) {
      case 'День' :
        return
          d.year == date.year &&
              d.month == date.month &&
              d.day == date.day;
        break;
      case 'Неделя':
        return
          d.year == lastWeekDay.year &&
              //d.month == lastWeekDay.month &&
              d.isBefore(lastWeekDay) && d.isAfter(lastWeekDay.subtract(Duration(days: 7)));
        break;
      case 'Месяц' :
        return
          d.year == date.year &&
              d.month == date.month;
        break;
      case 'Год' :
        return
          d.year == date.year;
        break;
    }
  }

  _getData(){
    switch(selMode){
      case 'День':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = date.subtract(Duration(days: 1));
                  updateData();
                });

              },
            ),
            MyText(date.toString().substring(0, 10)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 1));
                  updateData();
                });

              },
            ),
          ],
        );
      case 'Неделя':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  lastWeekDay = lastWeekDay.subtract(Duration(days: 7));
                  updateData();
                });
              },
            ),
            Row(
              children: [
                MyText(lastWeekDay.subtract(Duration(days: 6)).toString().substring(0, 10) + ' - '),
                MyText(lastWeekDay.toString().substring(0, 10)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  lastWeekDay = lastWeekDay.add(Duration(days: 7));
                  updateData();
                });
              },
            ),
          ],
        );
      case 'Месяц':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = new DateTime(date.year, date.month - 1, date.day);
                  updateData();
                });
              },
            ),
            MyText(AppLocalizations.of(context).translate(DateFormat.MMMM().format(date))+ ' '
                + DateFormat.y().format(date)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year, date.month + 1, date.day);
                  updateData();
                });
              },
            ),
          ],
        );
      case 'Год':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = new DateTime(date.year - 1, date.month, date.day);
                  updateData();
                });
              },
            ),
            MyText(date.year.toString()),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year + 1, date.month, date.day);
                  updateData();
                });
              },
            ),
          ],
        );
    }
  }

}
