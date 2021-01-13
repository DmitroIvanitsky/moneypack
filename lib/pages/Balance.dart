import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:money_pack/Objects/ListOfIncomes.dart';
import '../setting/SecondaryLocalText.dart';
import '../setting/SecondaryText.dart';
import '../Utility/appLocalizations.dart';
import '../widgets/customSnackBar.dart';
import '../setting/MainLocalText.dart';
import '../setting/DateFormatText.dart';
import '../setting/ThirdText.dart';
import '../pages/EditPageForExpenseCategory.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Utility/Storage.dart';
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

  @override
  void initState() {
    loadExpensesList();
    super.initState();
  }

  void loadExpensesList() async {
    String m = await Storage.getString('ExpenseNote');
    if (m != null) {
      setState(() {
        ListOfExpenses.fromJson(jsonDecode(m));
      });
    }
  }

  void updateExpensesPage() {
    setState(() {});
  }

  void updateDate(DateTime dateTime) {
    setState(() {
      date = dateTime;
    });
  }

  void undoDelete(ExpenseNote note, int index) async {
    if (index < ListOfExpenses.list.length)
      ListOfExpenses.list.insert(index, note);
    else
      ListOfExpenses.list.add(note);

    await Storage.saveString(
        jsonEncode(new ListOfExpenses().toJson()), 'ExpenseNote');
    updateExpensesPage();
  }

  double totalSum(List list) {
    double total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].sum;
    }
    return total;
  }

  String averageFunc(List list) {
    double average;
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum += list[i];
    }
    average = sum / list.length;
    return average.toStringAsFixed(2);
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
                              child: SecondaryText(
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
                          SecondaryText(text: toDateFormatMonth(index + 1)),
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

  String toDateFormatDay(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = 'Пн';
        break;
      case 2:
        dateFormat = 'Вт';
        break;
      case 3:
        dateFormat = 'Ср';
        break;
      case 4:
        dateFormat = 'Чт';
        break;
      case 5:
        dateFormat = 'Пт';
        break;
      case 6:
        dateFormat = 'Сб';
        break;
      case 7:
        dateFormat = 'Вс';
    }
    return dateFormat;
  }

  String toDateFormatMonth(int index) {
    String dateFormat;
    switch (index) {
      case 1:
        dateFormat = 'Январь';
        break;
      case 2:
        dateFormat = 'Февраль';
        break;
      case 3:
        dateFormat = 'Март';
        break;
      case 4:
        dateFormat = 'Апрель';
        break;
      case 5:
        dateFormat = 'Май';
        break;
      case 6:
        dateFormat = 'Июнь';
        break;
      case 7:
        dateFormat = 'Июль';
        break;
      case 8:
        dateFormat = 'Август';
        break;
      case 9:
        dateFormat = 'Сентябрь';
        break;
      case 10:
        dateFormat = 'Октябрь';
        break;
      case 11:
        dateFormat = 'Ноябрь';
        break;
      case 12:
        dateFormat = 'Декабрь';
        break;
    }
    return dateFormat;
  }

  Widget buildBottomAppBar() {
    return BottomAppBar(
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.mainColor,
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
        height: 60,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context)),
              MainLocalText(text: 'Расход'),
              buildDropdownButton(),
            ],
          ),
        ),
      ),
    );
  }

  double _childrenListLength(List list) {
    double height;
    if (list.length >= 5) {
      height = 250;
    } else {
      height = list.length.toDouble() * 50;
    }
    return height;
  }

  // creating main list according to date filter
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

  List<ExpenseNote> getFilteredChildrenOfCategory(ExpenseNote expenseNote, {int day}) {
    List<ExpenseNote> childrenList = [];
    if (selectedMode != 'Неделя(Д)') {
      for (int i = 0; i < ListOfExpenses.list.length; i++) {
        if (_isInFilter(ListOfExpenses.list[i].date) &&
            ListOfExpenses.list[i].category == expenseNote.category)
          childrenList.add(ListOfExpenses.list[i]);
      }
    } else {
      for (int i = 0; i < ListOfExpenses.list.length; i++) {
        if (_isInFilter(ListOfExpenses.list[i].date) &&
            ListOfExpenses.list[i].date.weekday == day &&
            ListOfExpenses.list[i].category == expenseNote.category)
          childrenList.add(ListOfExpenses.list[i]);
      }
    }
    return childrenList;
  }

  List<ExpenseNote> getFilteredChildrenListByDay(int day, List list) {
    List<ExpenseNote> middleByDayList = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].date.weekday == day) middleByDayList.add(list[i]);
    }
    List<ExpenseNote> resultByDayList = List();
    for (int i = 0; i < middleByDayList.length; i++) {
      bool isFound = false;
      ExpenseNote currentExpenseNote = middleByDayList[i];

      for (ExpenseNote E in resultByDayList) {
        if (currentExpenseNote.category == E.category) {
          isFound = true;
          break;
        }
      }
      if (isFound) continue;

      double sum = middleByDayList[i].sum;
      for (int j = i + 1; j < middleByDayList.length; j++) {
        if (currentExpenseNote.category == middleByDayList[j].category)
          sum += middleByDayList[j].sum;
      }
      resultByDayList.add(ExpenseNote(
          date: currentExpenseNote.date,
          category: currentExpenseNote.category,
          sum: sum,
          comment: currentExpenseNote.comment));
    }
    return resultByDayList;
  }

  // list which extract single notes from category (nested list)
  ListView getExpandedChildrenForCategory(List<ExpenseNote> middleList) {
    // ListView.getChildren and expanded to children
    return ListView.builder(
        itemCount: middleList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: boolComment(middleList[index]),
                    ),
                    Row(
                      children: [
                        SecondaryText(
                            text: middleList[index].sum.toStringAsFixed(2),
                            color: Colors.black54),
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.black54,
                          onPressed: () => goToEditPage(
                            context,
                            middleList[index],
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.black54,
                            onPressed: () async {
                              int indexInListOfExpenses = ListOfExpenses.list
                                  .indexOf(middleList[index]);
                              CustomSnackBar.show(
                                  key: scaffoldKey,
                                  context: context,
                                  text: AppLocalizations.of(context)
                                      .translate('Заметка удалена'),
                                  callBack: () {
                                    undoDelete(middleList[index],
                                        indexInListOfExpenses);
                                  });
                              ListOfExpenses.list.remove(middleList[index]);
                              await Storage.saveString(
                                  jsonEncode(new ListOfExpenses().toJson()),
                                  'ExpenseNote');
                              widget.updateMainPage();
                              updateExpensesPage();
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  ListView getExpandedChildrenForDay(List list, int day) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecondaryText(
                      text: list[index].category,
                      color: MyColors.secondTextColor),
                  SecondaryText(
                      text: list[index].sum.toStringAsFixed(2),
                      color: MyColors.secondTextColor),
                ],
              ),
            ),
          );
        });
  }

  boolComment(ExpenseNote note) {
    if (note.comment == '' || note.comment == null) {
      return DateFormatText(
          dateTime: note.date,
          mode: 'Дата в строке',
          color: MyColors.secondTextColor);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateFormatText(
              dateTime: note.date,
              mode: 'Дата в строке',
              color: MyColors.secondTextColor),
          comment(note),
        ],
      );
    }
  }

  goToEditPage(BuildContext context, ExpenseNote expenseNote) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return EditPageForExpenseCategory(
          updateExpensePage: updateExpensesPage,
          updateMainPage: widget.updateMainPage,
          note: expenseNote);
    }));
  }

  comment(ExpenseNote note) {
    if (note.comment == null)
      return ThirdText('');
    else
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: ThirdText(note.comment));
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
          updateExpensesPage();
        });
  }

  // date filter function
  _isInFilter(DateTime d) {
    if (d == null) return false;

    switch (selectedMode) {
      case 'День':
        return d.year == date.year &&
            d.month == date.month &&
            d.day == date.day;
        break;
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
      case 'Неделя(Д)':
        int weekDay = Localizations.localeOf(context).languageCode == 'ru' ||
                Localizations.localeOf(context).languageCode == 'uk'
            ? date.weekday
            : date.weekday + 1;
        DateTime nextWeekFirstDay =
            date.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return d.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            d.isBefore(nextWeekFirstDay);
        break;
      case 'Месяц':
        return d.year == date.year && d.month == date.month;
        break;
      case 'Год':
        return d.year == date.year;
        break;
    }
  }

  // function return date with buttons
  _getData() {
    switch (selectedMode) {
      case 'День':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = date.subtract(Duration(days: 1));
                });
              },
            ),
            DateFormatText(dateTime: date, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = date.add(Duration(days: 1));
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
      case 'Неделя(Д)':
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
      case 'Месяц':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                setState(() {
                  date = new DateTime(date.year, date.month - 1, date.day);
                });
              },
            ),
            DateFormatText(dateTime: date, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  date = DateTime(date.year, date.month + 1, date.day);
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
