import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_pack/interfaces/expense_service_interface.dart';

import '../Objects/record.dart';
import '../services/navigator_service.dart';
import '../widgets/large_local_text.dart';
import '../widgets/medium_text.dart';
import '../widgets/small_text.dart';
import '../widgets/app_dropdown_button.dart';
import '../widgets/date_widget.dart';
import '../widgets/secondary_local_text.dart';
import '../Utility/app_localizations.dart';
import '../widgets/custom_snack_bar.dart';
import '../widgets/date_format_text.dart';
import '../constants/app_colors.dart';
import '../widgets/main_row_text.dart';
import '../decorations/app_decorations.dart';


class ExpensesListPage extends StatefulWidget {
  final ExpenseServiceInterface expenseService;
  final NavigatorService navigatorService;

  ExpensesListPage({this.expenseService, this.navigatorService});

  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  DateTime date = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'Day';
  List <Note> expensesSortedByCategory = [];
  String langCode;

  @override
  void didChangeDependencies(){
    langCode = AppLocalizations.of(context).locale.toString();
    loadAllData();
    super.didChangeDependencies();
  }


  void loadAllData() async {
    List <Note> expensesFilteredByDate = await widget.expenseService.getFilteredList(context: context, selMode: selectedMode, currentDate: date);

    if (selectedMode == 'Week(D)'){
      expensesSortedByCategory = expensesFilteredByDate;
    } else {
      expensesSortedByCategory.clear();

      //Add unique ExpenseNotes to expensesSortedByCategory
      for (int i = 0; i < expensesFilteredByDate.length; i++) {
        Note currentExpenseNote = expensesFilteredByDate[i];
        double sum = expensesFilteredByDate[i].sum;
        bool isFound = false;

        for (Note note in expensesSortedByCategory) {
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
            Note(
                date: currentExpenseNote.date,
                category: currentExpenseNote.category,
                sum: sum,
                comment: currentExpenseNote.comment
            )
        );
      }
    }
    expensesSortedByCategory.sort((a, b) => b.date.compareTo(a.date));

    setState(() {});
  }

  void updateSelectedMode(String selMode){
    selectedMode = selMode;
    loadAllData();
  }

  void updateDate(DateTime dateTime) {
    date = dateTime;
    loadAllData();
  }

  void undoDelete(Note note, int index) async {
    widget.expenseService.addExpenseNote(note, index: index);
    loadAllData();
  }

  double sumList(List list) {
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

  String getSumByDayList(int index){
    List <String> sumByDay = [];
    String sum;

    for (int i = 1; i <= 7; i++){
      sumByDay.add(sumByDayMode(i, expensesSortedByCategory));
    }

    switch (index) {
      case 1:
        sum = langCode == 'en' ? sumByDay[6] : sumByDay[0];
        break;
      case 2:
        sum = langCode == 'en' ? sumByDay[0] : sumByDay[1];
        break;
      case 3:
        sum = langCode == 'en' ? sumByDay[1] : sumByDay[2];
        break;
      case 4:
        sum = langCode == 'en' ? sumByDay[2] : sumByDay[3];
        break;
      case 5:
        sum = langCode == 'en' ? sumByDay[3] : sumByDay[4];
        break;
      case 6:
        sum = langCode == 'en' ? sumByDay[4] : sumByDay[5];
        break;
      case 7:
        sum = langCode == 'en' ? sumByDay[5] : sumByDay[6];
    }
    return sum;
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

  double _calcHeightOnChildrenListLength(List list) {
    double height;
    if (list.length >= 5) {
      height = 250;
    } else {
      height = list.length.toDouble() * 50;
    }
    return height;
  }

  Future<List<Note>> getFilteredChildrenOfCategory(Note expenseNote) async {
    List<Note> childrenList = await widget.expenseService.getFilteredList(context: context, selMode: selectedMode, currentDate: date, currentCategory: expenseNote.category);

    childrenList.sort((a, b) => b.date.compareTo(a.date));
    return childrenList;
  }

  Future<List<Note>> getFilteredChildrenListByDay(int day) async {
    List<Note> middleByDayList = await widget.expenseService.getFilteredList(context: context, selMode: selectedMode, currentDate: date, day: day);
    List<Note> resultByDayList = [];

    for (int i = 0; i < middleByDayList.length; i++) {
      Note currentExpenseNote = middleByDayList[i];
      double sum = middleByDayList[i].sum;
      bool isFound = false;

      for (Note note in resultByDayList) {
        if (currentExpenseNote.category == note.category) {
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
          Note(
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
  ListView getExpandedChildrenForCategory(List<Note> middleList) {
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
                        child: boolComment(middleList[index])
                    ),
                    SecondaryText(
                        text: middleList[index].sum.toStringAsFixed(2)
                    ),
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
                int indexInListOfExpenses = (await widget.expenseService.readExpenseNotes()).list.indexOf(middleList[index]);
                   // ListOfExpenses.list.indexOf(middleList[index]);
                CustomSnackBar.show(
                    context: context,
                    text: AppLocalizations.of(context)
                        .translate('Note deleted'),
                    callBack: () {
                      undoDelete(middleList[index], indexInListOfExpenses);
                    });
                await widget.expenseService.deleteExpenseNote(middleList[index]);
                loadAllData();
              }
            },
            background: Container(
              alignment: Alignment.centerLeft,
              color: AppColors.EDIT_COLOR,
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

  ListView getExpandedChildrenForDay(List list) {
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
                  SecondaryText(text: list[index].category),
                  SecondaryText(text: list[index].sum.toStringAsFixed(2)),
                ],
              ),
            ),
          );
        });
  }

  boolComment(Note note) {
    if (note.comment == '' || note.comment == null) {
      return DateFormatText(
          dateTime: note.date,
          mode: 'date in string',
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateFormatText(
              dateTime: note.date,
              mode: 'date in string',
          ),
          comment(note),
        ],
      );
    }
  }

  goToEditPage(BuildContext context, Note expenseNote) async {
    await widget.navigatorService.navigateToEditExpensePage(
      context: context,
      note: expenseNote
    );
    loadAllData();
  }

  comment(Note note) {
    if (note.comment == null)
      return ThirdText('');
    else
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: ThirdText(note.comment));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainLocalText(text: 'Expense'),
              MainDropdownButton(page: 'expense', selectedMode: selectedMode, callBack: updateSelectedMode,)
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
            expensesSortedByCategory.isEmpty ?
            Expanded(
              child: Center(child: MainLocalText(text: 'No expenses'))
            )
            : Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Total'),
                      MainRowText(
                          text: sumList(expensesSortedByCategory).toStringAsFixed(2)
                      )
                    ],
                  ),
                ),
              ),
            selectedMode == 'Week(D)' && expensesSortedByCategory.isNotEmpty ?
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
                            SecondaryText(text: getSumByDayList(index + 1)),
                          ],
                        ),
                        backgroundColor: Theme.of(context).backgroundColor,
                        onExpansionChanged: (e) {},
                        children: [
                          FutureBuilder<List<Note>>(
                            initialData: [],
                            future: getFilteredChildrenListByDay(langCode == 'en' ? index : index + 1),
                            builder: (context, snapshot) {
                              if (snapshot.data.length > 0) {
                                return Container(
                                  height: _calcHeightOnChildrenListLength(snapshot.data),
                                  child: getExpandedChildrenForDay(snapshot.data),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
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
                          MainLocalText(text: 'weekly average'),
                          MainRowText(text: getWeekAverage(expensesSortedByCategory))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
            : Expanded(
                child: Builder(
                  builder: (context) {
                    return ListView.builder(
                      itemCount: expensesSortedByCategory.length,
                      itemBuilder: (context, index) {
                        Note singleCategoryNote = expensesSortedByCategory[index];
                        return ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SecondaryText(text: singleCategoryNote.category),
                              SecondaryText(text: singleCategoryNote.sum.toStringAsFixed(2)),
                            ],
                          ),
                          backgroundColor: Theme.of(context).backgroundColor,
                          onExpansionChanged: (e) {},
                          children: [
                            FutureBuilder<List<Note>>(
                            initialData: [],
                              future: getFilteredChildrenOfCategory(singleCategoryNote),
                              builder: (context, snapshot) {
                                if (snapshot.data.length > 0) {
                                  return                             Container(
                                    height: _calcHeightOnChildrenListLength(snapshot.data),
                                    child: getExpandedChildrenForCategory(snapshot.data),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              },
                            )
                          ],
                        );

                      }
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
