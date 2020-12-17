import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncomes.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddExpense.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/pages/Incomes.dart';
import 'package:flutter_tutorial/pages/Balance.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MainText.dart';
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
  String selectedMode = 'День';
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
      if (incN != null) ListOfIncomes.fromJson(jsonDecode(incN));
    });

    updateMainPage();
  }

  void updateMainPage() {
    setState(() {
      income = filterSumByPeriod(ListOfIncomes.list);
      expense = filterSumByPeriod(ListOfExpenses.list);
      balance = balanceFunc();
    });
  }

  double balanceFunc(){
    return ListOfIncomes.sum() - ListOfExpenses.sum();
  }

  double filterSumByPeriod(List list){
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
              child: MainText('Настройки'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MainText('Тема'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MainText('Язык'),
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
          MainText('Учёт'),
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
            child: Center(child: viewInfoButton(index: 'Доход', category: income)),
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
            child: Center(child: viewInfoButton(index: 'Расход', category: expense)),
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
            child: Center(child: viewInfoButton(index: 'Баланс общий', category: balance)),
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
          child: MainText(index)
      ),
    );
  }

  buildDropdownButton() {
    return DropdownButton(
        hint: MainText(selectedMode),
        items: [
          DropdownMenuItem(value: 'День', child: MainText('День')),
          DropdownMenuItem(value: 'Неделя', child: MainText('Неделя')),
          DropdownMenuItem(value: 'Месяц', child: MainText('Месяц')),
          DropdownMenuItem(value: 'Год', child: MainText('Год')),
        ],
        onChanged: (String newValue) {
          if (selectedMode == 'День' && newValue != 'День') {
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selectedMode == 'Неделя' && newValue != 'Неделя') {
            date = DateTime.now();
          }
          if (selectedMode == 'Месяц' && newValue != 'Месяц') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          if (selectedMode == 'Год' && newValue != 'Год') {
            date = DateTime.now();
            lastWeekDay = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: 7));
          }
          setState(() {
            selectedMode = newValue;
          });
          updateMainPage();
        }
    );
  }

  viewInfoButton({String index, double category}){
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
                child: MainText(index, TextAlign.left),
                onTap: () => _goTo(context, index)),
          ),
          MainText('$category', TextAlign.right),
        ],
      ),
    );
  }

  _goTo(BuildContext context, String index) {
    switch (index) {
      case 'Добавить расход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddExpenses(callBack: updateMainPage);
            }));
        break;
      case 'Добавить доход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return AddIncome(callback: updateMainPage);
            }));
        break;
      case 'Баланс общий':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return ShowBalance();
            }));
        break;
      case 'Доход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Incomes(updateMainPage: updateMainPage);
            }));
        break;
      case 'Расход':
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
              return Expenses(updateMainPage: updateMainPage);
            }));
        break;
    }
  }

  _isInFilter(DateTime d) {
    if (d == null) return false;

    switch (selectedMode) {
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
    switch(selectedMode){
      case 'День':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = date.subtract(Duration(days: 1));
                  updateMainPage();
                });

              },
            ),
            //MyText(date.toString().substring(0, 10)),
            MainText(
              AppLocalizations.of(context).translate(DateFormat.E().format(date)) +
              ', ' + DateFormat.d().format(date) +
              ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(date)) +
              ' ' + DateFormat.y().format(date),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 1));
                  updateMainPage();
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
                  updateMainPage();
                });
              },
            ),
            Row(
              children: [
                MainText(lastWeekDay.subtract(Duration(days: 6)).toString().substring(0, 10) + ' - '),
                MainText(lastWeekDay.toString().substring(0, 10)),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  lastWeekDay = lastWeekDay.add(Duration(days: 7));
                  updateMainPage();
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
                  updateMainPage();
                });
              },
            ),
            MainText(AppLocalizations.of(context).translate(DateFormat.MMMM().format(date))+ ' '
                + DateFormat.y().format(date)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year, date.month + 1, date.day);
                  updateMainPage();
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
                  updateMainPage();
                });
              },
            ),
            MainText(date.year.toString()),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year + 1, date.month, date.day);
                  updateMainPage();
                });
              },
            ),
          ],
        );
    }
  }

}
