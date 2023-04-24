import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_pack/interfaces/expense_service_interface.dart';
import 'package:money_pack/interfaces/income_service_interface.dart';
import '../Objects/record.dart';
import '../Utility/app_localizations.dart';
import '../services/navigator_service.dart';
import '../widgets/main_row_text.dart';
import '../widgets/large_local_text.dart';
import '../widgets/medium_text.dart';
import '../widgets/app_dropdown_button.dart';
import '../widgets/date_widget.dart';
import '../widgets/secondary_local_text.dart';
import '../decorations/app_decorations.dart';

class BalancePage extends StatefulWidget {
  BalancePage({this.incomeService, this.expenseService, this.navigatorService});

  final ExpenseServiceInterface expenseService;
  final IncomeServiceInterface incomeService;
  final NavigatorService navigatorService;

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  String langCode;

  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'Week';
  List sortedByCategoriesList = [];

  @override
  void didChangeDependencies(){
    loadAllData();
    super.didChangeDependencies();
  }


  void updateSelectedMode(String selMode){
    selectedMode = selMode;
    loadAllData();
  }

  void loadAllData() async {
    langCode = AppLocalizations.of(context).locale.toString();
    sortedByCategoriesList.clear();

    List <Note> incomeList = await widget.incomeService.getFilteredList(context: context, selMode: selectedMode, currentDate: date);
    List <Note> expenseList =  await widget.expenseService.getFilteredList(context: context, selMode: selectedMode, currentDate: date);

    for (Note note in incomeList) {
      sortedByCategoriesList.add(
        Note(
          date: note.date,
          sum: note.sum, category:
          note.category
        )
      );
    }
    for (Note note in expenseList) {
      sortedByCategoriesList.add(
          Note(
              date: note.date,
              sum: note.sum * -1,
              category: note.category
          )
      );
    }

    sortedByCategoriesList.sort((a, b) => b.date.compareTo(a.date));
    setState(() {});
  }

  void updateDate(DateTime dateTime) {
      date = dateTime;
      loadAllData();
  }

  double totalSum(List list) {
    double total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].sum;
    }
    return total;
  }

  String sumBySelectedMode(int index, List list) {
    double sum = 0;
    if (selectedMode == 'Year') {
      for (int i = 0; i < list.length; i++) {
        if (list[i].date.month == index) sum += list[i].sum;
      }
    }
    if (selectedMode == 'Week') {
      for (int i = 0; i < list.length; i++) {
        if (list[i].date.weekday == index) sum += list[i].sum;
      }
    }
    return sum.toStringAsFixed(2);
  }

  String getSumByDayLIst(int day){
    List <String> sumByDay = [];
    String resultAmount;

    for (int dayNumber = 1; dayNumber <= 7; dayNumber++){
      sumByDay.add(
          sumBySelectedMode(dayNumber, sortedByCategoriesList)
      );
    }

    switch (day) {
      case 1:
        resultAmount = langCode == 'en' ? sumByDay[6] : sumByDay[0];
        break;
      case 2:
        resultAmount = langCode == 'en' ? sumByDay[0] : sumByDay[1];
        break;
      case 3:
        resultAmount = langCode == 'en' ? sumByDay[1] : sumByDay[2];
        break;
      case 4:
        resultAmount = langCode == 'en' ? sumByDay[2] : sumByDay[3];
        break;
      case 5:
        resultAmount = langCode == 'en' ? sumByDay[3] : sumByDay[4];
        break;
      case 6:
        resultAmount = langCode == 'en' ? sumByDay[4] : sumByDay[5];
        break;
      case 7:
        resultAmount = langCode == 'en' ? sumByDay[5] : sumByDay[6];
    }
    return resultAmount;
  }

  String toDateFormatDay(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = langCode == 'en' ? 'Sun' : 'Mon';
        break;
      case 2:
        dateFormat = langCode == 'en' ? 'Mon' : 'Tue';
        break;
      case 3:
        dateFormat = langCode == 'en' ? 'Tue' : 'Wed';
        break;
      case 4:
        dateFormat = langCode == 'en' ? 'Wed' : 'Thu';
        break;
      case 5:
        dateFormat = langCode == 'en' ? 'Thu' : 'Fri';
        break;
      case 6:
        dateFormat = langCode == 'en' ? 'Fri' : 'Sat';
        break;
      case 7:
        dateFormat = langCode == 'en' ? 'Sat' : 'Sun';
    }
    return dateFormat;
  }

  String toDateFormatMonth(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = 'January';
        break;
      case 2:
        dateFormat = 'February';
        break;
      case 3:
        dateFormat = 'March';
        break;
      case 4:
        dateFormat = 'April';
        break;
      case 5:
        dateFormat = 'May';
        break;
      case 6:
        dateFormat = 'June';
        break;
      case 7:
        dateFormat = 'July';
        break;
      case 8:
        dateFormat = 'August';
        break;
      case 9:
        dateFormat = 'September';
        break;
      case 10:
        dateFormat = 'October';
        break;
      case 11:
        dateFormat = 'November';
        break;
      case 12:
        dateFormat = 'December';
        break;
    }
    return dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainLocalText(text: 'Balance'),
              MainDropdownButton(page: 'balance', selectedMode: selectedMode, callBack: updateSelectedMode,)
            ],
          ), // dropdown menu button
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10),
              child: Container(
                height: 50,
                width: 300,
                decoration: AppDecoration.boxDecoration(context),
                child: DateWidget(selMode: selectedMode, date: date, update: updateDate),
              ),
            ),
            sortedByCategoriesList.isEmpty ?
            Expanded(child: Center(child: MainLocalText(text: 'No entries')))
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Balance for the period'),
                      MainRowText(text: totalSum(sortedByCategoriesList).toStringAsFixed(2))
                    ],
                  ),
                ),
            ),
            if (selectedMode == 'Week' && sortedByCategoriesList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: SecondaryLocalText(text: toDateFormatDay(index + 1))),
                            SecondaryText(text: getSumByDayLIst(index + 1)),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
            if (selectedMode == 'Year' && sortedByCategoriesList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SecondaryLocalText(text: toDateFormatMonth(index + 1)),
                            SecondaryText(text: sumBySelectedMode((index + 1), sortedByCategoriesList)),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }

}
