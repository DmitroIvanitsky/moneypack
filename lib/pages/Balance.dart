import 'package:flutter/material.dart';
import '../Objects/ListOfIncomes.dart';
import '../setting/SecondaryLocalText.dart';
import '../setting/SecondaryText.dart';
import '../setting/MainLocalText.dart';
import '../setting/DateFormatText.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';

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
  List<double> listForAvgFunc = [];

  void updateBalancePage() {
    setState(() {});
  }

  double totalSum(List list) {
    double total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].sum;
    }
    return total;
  }

  // function to only one view mode 'Неделя(Д)'
  String sumByDay(int index, List list) {
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
    if (sum > 0) listForAvgFunc.add(sum);
    return sum.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyColors.backGroundColor,
        //bottomNavigationBar: buildBottomAppBar(),
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      shadowColor: Colors.black,
      iconTheme: IconThemeData(color: MyColors.textColor),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [MainLocalText(text: 'Баланс'), buildDropdownButton()],
      ), // dropdown menu button
    );
  }

  Widget buildBody() {
    List categoriesList = filteredExpenses();
    categoriesList.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: [
        _getData(),
        Divider(),
        categoriesList.isEmpty
            ? Expanded(child: Center(child: MainLocalText(text: 'Записей нет')))
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Баланс за период'),
                      MainRowText(
                          text: totalSum(categoriesList).toStringAsFixed(2))
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
                          Expanded(
                              child: SecondaryLocalText(
                                  text: toDateFormatDay(index + 1))),
                          SecondaryText(
                              text: sumByDay((index + 1), categoriesList)),
                        ],
                      ),
                    ),
                  );
                }),
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
                          SecondaryText(
                              text: sumByDay((index + 1), categoriesList)),
                        ],
                      ),
                    ),
                  );
                }),
          ),
      ],
    );
  }

  List filteredExpenses() {
    List middleIncomeList = List();
    for (int i = 0; i < ListOfIncomes.list.length; i++) {
      if (_isInFilter(ListOfIncomes.list[i].date))
        middleIncomeList.add(ListOfIncomes.list[i]);
    }
    List middleExpenseList = List();
    for (int i = 0; i < ListOfExpenses.list.length; i++) {
      if (_isInFilter(ListOfExpenses.list[i].date))
        middleExpenseList.add(ListOfExpenses.list[i]);
    }
    List resultList = List();
    for (int i = 0; i < middleIncomeList.length; i++) {
      resultList.add(ExpenseNote(
          date: middleIncomeList[i].date, sum: middleIncomeList[i].sum));
    }
    for (int i = 0; i < middleExpenseList.length; i++) {
      resultList.add(ExpenseNote(
          date: middleExpenseList[i].date, sum: middleExpenseList[i].sum * -1));
    }
    return resultList;
  }

  String toDateFormatDay(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = 'Mon';
        break;
      case 2:
        dateFormat = 'Tue';
        break;
      case 3:
        dateFormat = 'Wed';
        break;
      case 4:
        dateFormat = 'Thu';
        break;
      case 5:
        dateFormat = 'Fri';
        break;
      case 6:
        dateFormat = 'Sat';
        break;
      case 7:
        dateFormat = 'Sun';
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

  // dropdown menu button
  Widget buildDropdownButton() {
    return DropdownButton(
        hint: MainLocalText(text: selectedMode),
        items: [
          DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
          DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
        ],
        onChanged: (String newValue) {
          selectedMode = newValue;
          updateBalancePage();
        });
  }

  // date filter function
  _isInFilter(DateTime d) {
    if (d == null) return false;

    switch (selectedMode) {
      case 'Неделя':
        int weekDay = Localizations.localeOf(context).languageCode == 'ru' ||
                Localizations.localeOf(context).languageCode == 'uk'
            ? date.weekday
            : date.weekday + 1;
        DateTime nextWeekFirstDay =
            date.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return d.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            d.isBefore(nextWeekFirstDay);
        break;
      case 'Год':
        return d.year == date.year;
        break;
    }
  }

  // function return date with buttons
  _getData() {
    switch (selectedMode) {
      case 'Неделя':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = date.subtract(Duration(days: 7));
                });
              },
            ),
            DateFormatText(dateTime: date, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 7));
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
                });
              },
            ),
            DateFormatText(dateTime: date, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year + 1, date.month, date.day);
                });
              },
            ),
          ],
        );
    }
  }
}
