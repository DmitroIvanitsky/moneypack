import 'package:flutter/material.dart';
import 'package:money_pack/Objects/IncomeNote.dart';
import 'package:money_pack/widgets/AppDropdownButton.dart';
import '../Utility/Storage.dart';
import '../widgets/DateWidget.dart';
import '../Objects/ListOfIncomes.dart';
import '../setting/SecondaryLocalText.dart';
import '../setting/SecondaryText.dart';
import '../setting/MainLocalText.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../setting/AppColors.dart';
import '../setting/MainRowText.dart';
import '../setting/AppDecoration.dart';

class Balance extends StatefulWidget {
  final Function updateMainPage;

  Balance({this.updateMainPage});

  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'Неделя';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List categoriesList = [];

  @override
  void initState() {
    loadCategoryList();
    super.initState();
  }

  void updateBalancePage() {
    setState(() {
      loadCategoryList();
    });
  }

  void updateSelectedMode(String selMode){
    selectedMode = selMode;
    updateBalancePage();
  }

  void loadCategoryList() {
    categoriesList.clear();

    List <IncomeNote> incomeList = ListOfIncomes.filtered(selMode: selectedMode, currentDate: date);
    List <ExpenseNote> expenseList = ListOfExpenses.filtered(selMode: selectedMode, currentDate: date);

    for (IncomeNote note in incomeList) {
      categoriesList.add(IncomeNote(date: note.date, sum: note.sum));
    }
    for (ExpenseNote note in expenseList) {
      categoriesList.add(ExpenseNote(date: note.date, sum: note.sum * -1));
    }

    categoriesList.sort((a, b) => b.date.compareTo(a.date));
  }

  void updateDate(DateTime dateTime) {
      date = dateTime;
      updateBalancePage();
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
    if (selectedMode == 'Год') {
      for (int i = 0; i < list.length; i++) {
        if (list[i].date.month == index) sum += list[i].sum;
      }
    }
    if (selectedMode == 'Неделя') {
      for (int i = 0; i < list.length; i++) {
        if (list[i].date.weekday == index) sum += list[i].sum;
      }
    }
    return sum.toStringAsFixed(2);
  }

  String getSumByDayLIst(int index){
    List <String> sumByDay = [];
    String sum;

    for (int i = 1; i <= 7; i++){
      sumByDay.add(sumBySelectedMode(i, categoriesList));
    }

    switch (index) {
      case 1:
        sum = Storage.langCode == 'en' ? sumByDay[6] : sumByDay[0];
        break;
      case 2:
        sum = Storage.langCode == 'en' ? sumByDay[0] : sumByDay[1];
        break;
      case 3:
        sum = Storage.langCode == 'en' ? sumByDay[1] : sumByDay[2];
        break;
      case 4:
        sum = Storage.langCode == 'en' ? sumByDay[2] : sumByDay[3];
        break;
      case 5:
        sum = Storage.langCode == 'en' ? sumByDay[3] : sumByDay[4];
        break;
      case 6:
        sum = Storage.langCode == 'en' ? sumByDay[4] : sumByDay[5];
        break;
      case 7:
        sum = Storage.langCode == 'en' ? sumByDay[5] : sumByDay[6];
    }
    return sum;
  }

  String toDateFormatDay(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = Storage.langCode == 'en' ? 'Sun' : 'Mon';
        break;
      case 2:
        dateFormat = Storage.langCode == 'en' ? 'Mon' : 'Tue';
        break;
      case 3:
        dateFormat = Storage.langCode == 'en' ? 'Tue' : 'Wed';
        break;
      case 4:
        dateFormat = Storage.langCode == 'en' ? 'Wed' : 'Thu';
        break;
      case 5:
        dateFormat = Storage.langCode == 'en' ? 'Thu' : 'Fri';
        break;
      case 6:
        dateFormat = Storage.langCode == 'en' ? 'Fri' : 'Sat';
        break;
      case 7:
        dateFormat = Storage.langCode == 'en' ? 'Sat' : 'Sun';
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
        key: scaffoldKey,
        backgroundColor: AppColors.backGroundColor(),
        appBar: AppBar(
          shadowColor: AppColors.backGroundColor().withOpacity(.001),
          iconTheme: IconThemeData(color: AppColors.textColor()),
          backgroundColor: AppColors.backGroundColor(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainLocalText(text: 'Баланс'),
              AppDropdownButton(page: 'balance', selectedMode: selectedMode, updateSelMode: updateSelectedMode,)
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
                child: DateWidget.getDate(selMode: selectedMode, date: date, update: updateDate, color: AppColors.textColor()),
              ),
            ),
            categoriesList.isEmpty ?
            Expanded(child: Center(child: MainLocalText(text: 'Записей нет')))
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Баланс за период'),
                      MainRowText(text: totalSum(categoriesList).toStringAsFixed(2))
                    ],
                  ),
                ),
            ),
            if (selectedMode == 'Неделя' && categoriesList.isNotEmpty)
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
            if (selectedMode == 'Год' && categoriesList.isNotEmpty)
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
                            SecondaryText(text: sumBySelectedMode((index + 1), categoriesList)),
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
