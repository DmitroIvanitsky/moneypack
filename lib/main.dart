import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_pack/Objects/ListOfExpenses.dart';
import 'package:money_pack/Objects/ListOfIncomes.dart';
import 'package:money_pack/Utility/Storage.dart';
import 'package:money_pack/pages/AddExpense.dart';
import 'package:money_pack/pages/AddIncome.dart';
import 'package:money_pack/pages/Balance.dart';
import 'package:money_pack/pages/Expenses.dart';
import 'package:money_pack/pages/Incomes.dart';
import 'package:money_pack/setting/MainLocalText.dart';
import 'package:money_pack/setting/MyColors.dart';
import 'package:money_pack/setting/SecondaryText.dart';
import 'package:money_pack/widgets/DateWidget.dart';
import 'package:money_pack/widgets/rowWithButton.dart';
import 'Utility/appLocalizations.dart';


import 'package:gx_file_picker/gx_file_picker.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(fontFamily: 'main',),
  debugShowCheckedModeBanner: false,
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
  home: MoneyPack(),
));

class MoneyPack extends StatefulWidget {
  @override
  _MoneyPackState createState() => _MoneyPackState();
}

class _MoneyPackState extends State<MoneyPack> {
  DateTime date = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'День';
  double income = 0;
  double expense = 0;
  double balance = 0;
  double totalBalance = 0;

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

  void updateDate(DateTime dateTime) {
      date = dateTime;
      updateMainPage();
  }

  void updateMainPage() async {
    setState(() {
      income = filterSumByPeriod(ListOfIncomes.filtered(selMode: selectedMode, currentDate: date));
      expense = filterSumByPeriod(ListOfExpenses.filtered(selMode: selectedMode, currentDate: date));
      balance = income - expense;
      totalBalance = remainFunc();
    });
  }

  double remainFunc(){
    return ListOfIncomes.sum() - ListOfExpenses.sum();
  }

  double filterSumByPeriod(List list){
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
        sum += list[i].sum;
    }
    return sum;
  }

  buildDrawer(){
    return Container(
      width: 350,
      child: Drawer(
        child: Container(
          color: MyColors.backGroundColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: MyColors.boxDecoration,
                child: FlatButton(
                  child: MainLocalText(text: 'сохранить резервную копию'),
                  onPressed: () => Storage.saveBackup(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: MyColors.boxDecoration,
                child: FlatButton(
                  child: MainLocalText(text: 'загрузить резервную копию'),
                  onPressed: () async {
                    File file =  await FilePicker.getFile(
                        type: FileType.custom,
                        allowedExtensions: ['json']
                    );
                    if (file != null) {
                      await Storage.loadBackup(file);
                      await loadList();
                      updateMainPage();
                      Navigator.of(context).pop();
                    }
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownButton() {
    return DropdownButton(
      iconEnabledColor: MyColors.textColor2,
      iconDisabledColor: MyColors.textColor2,
      dropdownColor: MyColors.backGroundColor,
      hint: MainLocalText(text: selectedMode),
      items: [
        DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
        DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
        DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
        DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
      ],
        onChanged: (String newValue) {
          selectedMode = newValue;
          updateMainPage();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Storage.langCode = AppLocalizations.of(context).locale.toString();

    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            endDrawerEnableOpenDragGesture: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColors.backGroundColor,
            drawer: buildDrawer(),
            appBar: AppBar(
              shadowColor: MyColors.backGroundColor.withOpacity(.01),
              iconTheme: IconThemeData(color: MyColors.textColor2),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainLocalText(text: 'Учёт'),
                  buildDropdownButton(),
                ],
              ),
              centerTitle: true,
              backgroundColor: MyColors.backGroundColor,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: MyColors.boxDecoration,
                      child: DateWidget.getDate(selMode: selectedMode, date: date, update: updateDate, color: MyColors.textColor2),
                    ),
                  ),
                  RowWithButton(
                    leftText: 'Доход',
                    rightText: income.toStringAsFixed(2),
                    onTap: () =>
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => Incomes(updateMainPage: updateMainPage)
                          ),
                        ),
                  ),
                  RowWithButton(
                    leftText: 'Расход',
                    rightText: expense.toStringAsFixed(2),
                    onTap: () =>
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => Expenses(updateMainPage: updateMainPage)
                          ),
                        ),
                  ),
                  RowWithButton(
                    leftText: 'Баланс',
                    rightText: balance.toStringAsFixed(2),
                    onTap: () =>
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => Balance(updateMainPage: updateMainPage)
                          ),
                        ),
                  ),
                  Container(
                      decoration: MyColors.boxDecoration,
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainLocalText(text: 'Общий остаток'),
                                SecondaryText(text: totalBalance.toStringAsFixed(2), color: MyColors.textColor2,),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  // low buttons to add notes
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: MyColors.boxDecoration,
                            height: 70,
                            width: 215,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.incomeButton,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FlatButton(
                                height: 70,
                                minWidth: 215,
                                child: MainLocalText(text: 'Добавить доход'),
                                onPressed: () =>
                                    Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => AddIncome(callback: updateMainPage)
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: MyColors.boxDecoration,
                            height: 70,
                            width: 215,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.expenseButton,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FlatButton(
                                height: 70,
                                minWidth: 215,
                                child: Center(child: MainLocalText(text: 'Добавить расход')),
                                onPressed: () =>
                                    Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => AddExpenses(callBack: updateMainPage)),
                                    ),
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

}
