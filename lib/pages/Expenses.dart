import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/DateWidget.dart';
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

class Expenses extends StatefulWidget {
  final Function updateMainPage;

  Expenses({this.updateMainPage});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'День';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List <ExpenseNote> expensesSortedByCategory = [];

  @override
  void initState() {
    loadExpensesList();
    setExpSortCatList();
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

  void setExpSortCatList() {
    List <ExpenseNote> expensesFilteredByDate = List();

    for (ExpenseNote note in ListOfExpenses.list) {
      if (_isInFilter(note.date))
        expensesFilteredByDate.add(note);
    }

    if (selectedMode == 'Неделя(Д)'){
      expensesSortedByCategory = expensesFilteredByDate;
    } else {
      expensesSortedByCategory.clear();

      //Add unique ExpenseNotes to expensesSortedByCategory
      for (int i = 0; i < expensesFilteredByDate.length; i++) {
        ExpenseNote currentExpenseNote = expensesFilteredByDate[i];
        double sum = expensesFilteredByDate[i].sum;
        bool isFound = false;

        for (ExpenseNote note in expensesSortedByCategory) {
          if (currentExpenseNote.category == note.category) {
            isFound = true;
            break;
          }
        }
        if (isFound) continue; //ExpenseNote already added, skip

        //sum all same category ExpenseNotes
        for (int j = i + 1; j < expensesFilteredByDate.length; j++) {
          if (currentExpenseNote.category == expensesFilteredByDate[j].category)
            sum += expensesFilteredByDate[j].sum;
        }

        expensesSortedByCategory.add(
            ExpenseNote(
                date: currentExpenseNote.date,
                category: currentExpenseNote.category,
                sum: sum,
                comment: currentExpenseNote.comment
            )
        );
      }
    }
    expensesSortedByCategory.sort((a, b) => b.date.compareTo(a.date));
  }

  void updateExpensesPage() {
    setState(() {
      setExpSortCatList();
    });
  }

  void updateDate(DateTime dateTime) {
    date = dateTime;
    updateExpensesPage();
  }

  void undoDelete(ExpenseNote note, int index) async {
    if (index < ListOfExpenses.list.length)
      ListOfExpenses.list.insert(index, note);
    else
      ListOfExpenses.list.add(note);

    await Storage.saveString(
        jsonEncode(new ListOfExpenses().toJson()), 'ExpenseNote');
    updateExpensesPage();
    widget.updateMainPage();
  }

  double totalSum(List list) {
    double total = 0;
    for (int i = 0; i < list.length; i++) {
      total += list[i].sum;
    }
    return total;
  }

  String getWeekAverage(List list) {
    double average;
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum += list[i].sum;
    }
    average = sum / 7;
    return average.toStringAsFixed(2);
  }

  String sumByDayMode(int day, List list) {
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].date.weekday == day) sum += list[i].sum;
    }
    return sum.toStringAsFixed(2);
  }

  String getSumByDayLIst(int index){
    List <String> sumByDay = [];
    String sum;

    for (int i = 1; i <= 7; i++){
      sumByDay.add(sumByDayMode(i, expensesSortedByCategory));
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

  double _calcHeightOnChildrenListLength(List list) {
    double height;
    if (list.length >= 5) {
      height = 250;
    } else {
      height = list.length.toDouble() * 50;
    }
    return height;
  }

  List<ExpenseNote> getFilteredChildrenOfCategory(ExpenseNote expenseNote) {
    List<ExpenseNote> childrenList = [];

    for (ExpenseNote note in ListOfExpenses.list) {
      if (_isInFilter(note.date) && note.category == expenseNote.category)
        childrenList.add(note);
    }

    childrenList.sort((a, b) => b.date.compareTo(a.date));
    return childrenList;
  }

  List<ExpenseNote> getFilteredChildrenListByDay(int day, List list) {
    List<ExpenseNote> middleByDayList = [];

    for (ExpenseNote note in list) {
      if (note.date.weekday == day)
        middleByDayList.add(note);
    }

    List<ExpenseNote> resultByDayList = List();

    for (int i = 0; i < middleByDayList.length; i++) {
      ExpenseNote currentExpenseNote = middleByDayList[i];
      double sum = middleByDayList[i].sum;
      bool isFound = false;

      for (ExpenseNote E in resultByDayList) {
        if (currentExpenseNote.category == E.category) {
          isFound = true;
          break;
        }
      }
      if (isFound) continue;

      for (int j = i + 1; j < middleByDayList.length; j++) {
        if (currentExpenseNote.category == middleByDayList[j].category)
          sum += middleByDayList[j].sum;
      }
      resultByDayList.add(
        ExpenseNote(
          date: currentExpenseNote.date,
          category: currentExpenseNote.category,
          sum: sum,
          comment: currentExpenseNote.comment
        )
      );
    }
    return resultByDayList;
  }

  //list which extract single notes from category (nested list)
  ListView getExpandedChildrenForCategory(List<ExpenseNote> middleList) {
    // ListView.getChildren and expanded to children
    return ListView.builder(
        itemCount: middleList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: new GlobalKey(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: boolComment(middleList[index]),
                    ),
                    SecondaryText(
                        text: middleList[index].sum.toStringAsFixed(2),
                        color: Colors.black54),
                  ],
                ),
              ),
            ),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd)
                return goToEditPage(context, middleList[index]);
              else
                return true;
            },
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                int indexInListOfExpenses =
                    ListOfExpenses.list.indexOf(middleList[index]);
                CustomSnackBar.show(
                    key: scaffoldKey,
                    context: context,
                    text: AppLocalizations.of(context)
                        .translate('Заметка удалена'),
                    callBack: () {
                      undoDelete(middleList[index], indexInListOfExpenses);
                    });
                ListOfExpenses.list.remove(middleList[index]);
                await Storage.saveString(
                    jsonEncode(new ListOfExpenses().toJson()), 'ExpenseNote');
                widget.updateMainPage();
                updateExpensesPage();
              }
            },
            background: Container(
              alignment: Alignment.centerLeft,
              color: MyColors.edit,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.edit,
                  color: Colors.black54,
                ),
              ),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              color: Colors.redAccent,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.delete,
                  color: Colors.black54,
                ),
              ),
            ),
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
          DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
          DropdownMenuItem(
              value: 'Неделя', child: MainLocalText(text: 'Неделя')),
          DropdownMenuItem(
              value: 'Неделя(Д)', child: MainLocalText(text: 'Неделя(Д)')),
          DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyColors.backGroundColor,
        appBar: AppBar(
          shadowColor: Colors.black,
          iconTheme: IconThemeData(color: MyColors.textColor),
          backgroundColor: MyColors.mainColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [MainLocalText(text: 'Расход'), buildDropdownButton()],
          ), // dropdown menu button
        ),
        body: Column(
          children: [
            DateWidget.getDate(
                selectedMode: selectedMode, date: date, update: updateDate),
            Divider(),
            expensesSortedByCategory.isEmpty ?
            Expanded(
              child: Center(child: MainLocalText(text: 'Расходов нет'))
            )
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Итого'),
                      MainRowText(
                          text: totalSum(expensesSortedByCategory).toStringAsFixed(2)
                      )
                    ],
                  ),
                ),
              ),
            selectedMode == 'Неделя(Д)' && expensesSortedByCategory.isNotEmpty ?
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SecondaryLocalText(text: toDateFormatDay(index + 1)),
                            SecondaryText(text: getSumByDayLIst(index + 1)),
                          ],
                        ),
                        backgroundColor: MyColors.backGroundColor,
                        onExpansionChanged: (e) {},
                        children: [
                          Container(
                            height: _calcHeightOnChildrenListLength(getFilteredChildrenListByDay(index + 1, expensesSortedByCategory)),
                            child: getExpandedChildrenForDay(getFilteredChildrenListByDay(index + 1, expensesSortedByCategory), index + 1),
                          )
                        ],
                      );
                    },
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainLocalText(text: 'Среднее за неделю'),
                          MainRowText(text: getWeekAverage(expensesSortedByCategory))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
            : Expanded(
                child: ListView.builder(
                  itemCount: expensesSortedByCategory.length,
                  itemBuilder: (context, index) {
                    ExpenseNote singleCategoryNote = expensesSortedByCategory[index];
                    List<ExpenseNote> childrenList = getFilteredChildrenOfCategory(singleCategoryNote);

                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SecondaryText(text: singleCategoryNote.category),
                          SecondaryText(text: singleCategoryNote.sum.toStringAsFixed(2)),
                        ],
                      ),
                      backgroundColor: MyColors.backGroundColor,
                      onExpansionChanged: (e) {},
                      children: [
                        Container(
                          height: _calcHeightOnChildrenListLength(childrenList),
                          child: getExpandedChildrenForCategory(childrenList),
                        )
                      ],
                    );
                  }
                ),
            )
          ],
        ),
      ),
    );
  }
}
