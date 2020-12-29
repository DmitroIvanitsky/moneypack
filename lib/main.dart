import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Objects/ListOfIncomes.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/AddExpense.dart';
import 'package:flutter_tutorial/pages/AddIncome.dart';
import 'package:flutter_tutorial/pages/Expenses.dart';
import 'package:flutter_tutorial/pages/Incomes.dart';
import 'package:flutter_tutorial/setting/DateFormatText.dart';
import 'package:flutter_tutorial/setting/MainLocalText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';
import 'package:flutter_tutorial/setting/SecondaryText.dart';
import 'package:flutter_tutorial/widgets/rowWithButton.dart';
import 'Utility/appLocalizations.dart';

void main() => runApp(MaterialApp(
  //debugShowCheckedModeBanner: true,
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
    const Locale.fromSubtags(languageCode: 'uk'),
  ],
  home: FlutterTutorialApp(),
));

class FlutterTutorialApp extends StatefulWidget {
  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {
  DateTime date = DateTime.now();
  String selectedMode = 'День';
  double income = 0;
  double expense = 0;
  double balance = 0;
  double remain = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([ //Lock orientation
      DeviceOrientation.portraitUp,
    ]);
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

  void updateMainPage() async {
    setState(() {
      income = filterSumByPeriod(ListOfIncomes.list);
      expense = filterSumByPeriod(ListOfExpenses.list);
      balance = income - expense;
      remain = remainFunc();
    });
  }

  double remainFunc(){
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

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.backGroundColor,
        //drawer: buildDrawer(),
        //bottomNavigationBar: buildBottomAppBar(),
        appBar: buildAppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getDate(),
              RowWithButton(
                leftText: 'Доход',
                rightText: income.toString(),
                onTap: () =>
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Incomes(updateMainPage: updateMainPage)),
                  ),
              ),
              RowWithButton(
                leftText: 'Расход',
                rightText: expense.toString(),
                  onTap: () =>
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Expenses(updateMainPage: updateMainPage)),
                    ),
              ),
              // balance row
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: MyColors.rowColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 5
                      )
                    ]
                ),
                height: 70,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainLocalText(text: 'Баланс'),
                          SecondaryText(text: balance.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainLocalText(text: 'Остаток'),
                          SecondaryText(text: remain.toString()),
                        ],
                      ),
                    ],
                  ),
                )
              ),
              // low buttons to add notes
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.incomeButton,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5
                              )
                            ]
                        ),
                        height: 70,
                        width: 200,

                        child: FlatButton(
                          child: MainLocalText(text: 'Добавить доход'),
                          onPressed: () =>
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => AddIncome(callback: updateMainPage)),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.expenseButton,
                          borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 5
                              )
                            ]
                        ),
                        height: 70,
                        width: 200,
                        
                        child: FlatButton(
                          child: MainLocalText(text: 'Добавить расход'),
                          onPressed: () =>
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddExpenses(callBack: updateMainPage)),
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.mainColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 5
              )
            ]
          ),
          height: 60,
          child: Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(icon: Icon(Icons.menu, color: Colors.black),
                  //     onPressed: () {
                  //       scaffoldKey.currentState.openDrawer();
                  // }),
                  MainLocalText(text: 'Учёт'),
                  buildDropdownButton(),
                ],
            ),
          ),
        ),
      );
  }

  getDate(){
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
            DateFormatText(dateTime: date, mode: selectedMode),
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
                  date = date.subtract(Duration(days: 7));
                  updateMainPage();
                });
              },
            ),
            DateFormatText(dateTime: date, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 7));
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
            DateFormatText(dateTime: date, mode: selectedMode),
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
            DateFormatText(dateTime: date, mode: selectedMode),
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

  buildDrawer(){
    return Drawer(
      child: Container(
        color: MyColors.backGroundColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MainRowText(text: 'Настройки'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MainRowText(text: 'Тема'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: MainRowText(text: 'Язык'),
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
          MainLocalText(text: 'Учёт'),
          buildDropdownButton(),
        ],
      ),
      centerTitle: true,
      backgroundColor: MyColors.mainColor,
    );
  }

  Widget buildDropdownButton() {
    return DropdownButton(
        hint: MainLocalText(text: selectedMode),
        items: [
          DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
          DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
          DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
          DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
        ],
        onChanged: (String newValue) {
          if (selectedMode != 'Неделя' && newValue == 'Неделя') {
            date = date.subtract(Duration(days: date.weekday + 1)).add(Duration(days: 7));
          }

          if (selectedMode == 'Неделя' && newValue != 'Неделя') {
            date = DateTime.now();
          }

          setState(() {
            selectedMode = newValue;
          });
          updateMainPage();
        }
    );
  }

  _isInFilter(DateTime d){
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
          d.year == date.year &&
              d.month == date.month &&
              d.isBefore(date) && d.isAfter(date.subtract(Duration(days: 7)));
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
}
