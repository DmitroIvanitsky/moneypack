import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_pack/setting/expansionTileTheme.dart';
import '../setting/AppDecoration.dart';
import '../widgets/AppDropdownButton.dart';
import '../widgets/DateWidget.dart';
import '../setting/SecondaryLocalText.dart';
import '../setting/SecondaryText.dart';
import '../Utility/appLocalizations.dart';
import '../widgets/customSnackBar.dart';
import '../setting/MainLocalText.dart';
import '../setting/DateFormatText.dart';
import '../setting/ThirdText.dart';
import '../pages/EditPageForIncomeCategory.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfIncomes.dart';
import '../Utility/Storage.dart';
import '../setting/AppColors.dart';
import '../setting/MainRowText.dart';


class Incomes extends StatefulWidget {
  final Function updateMainPage;

  Incomes({this.updateMainPage});

  @override
  _IncomesState createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {
  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'День';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List <IncomeNote> incomesSortedByCategory = [];

  @override
  void initState() {
    loadIncomeList();
    setIncSortCatList();
    super.initState();
  }

  void loadIncomeList() async {
    String m = await Storage.getString('IncomeNote');
    if (m != null) {
      setState(() {
        ListOfIncomes.fromJson(jsonDecode(m));
      });
    }
  }

  void setIncSortCatList() {
    List <IncomeNote> incomesFilteredByDate = ListOfIncomes.filtered(selMode: selectedMode, currentDate: date);

    if (selectedMode == 'Неделя(Д)'){
      incomesSortedByCategory = incomesFilteredByDate;
    } else {
      incomesSortedByCategory.clear();

      //add unique IncomeNotes to incomesSortedByCategory
      for (int i = 0; i < incomesFilteredByDate.length; i++) {
        IncomeNote currentIncomeNote = incomesFilteredByDate[i];
        double sum = incomesFilteredByDate[i].sum;
        bool isFound = false;

        for (IncomeNote note in incomesSortedByCategory) {
          if (currentIncomeNote.category == note.category) {
            isFound = true;
            break;
          }
        }
        if (isFound) continue; // IncomeNote already added, skip

        //sum all same category IncomeNote
        for (int j = i + 1; j < incomesFilteredByDate.length; j++) {
          if (currentIncomeNote.category == incomesFilteredByDate[j].category)
            sum += incomesFilteredByDate[j].sum;
        }
        incomesSortedByCategory.add(
          IncomeNote(
            date: currentIncomeNote.date,
            category: currentIncomeNote.category,
            sum: sum,
            comment: currentIncomeNote.comment
          )
        );
      }
    }
    incomesSortedByCategory.sort((a, b) => b.date.compareTo(a.date));
  }

  void updateIncomesPage() {
    setState(() {
      setIncSortCatList();
    });
  }

  void updateSelectedMode(String selMode){
    selectedMode = selMode;
    updateIncomesPage();
  }

  void updateDate(DateTime dateTime) {
    date = dateTime;
    updateIncomesPage();
  }

  void undoDelete(IncomeNote note, int index) async {
    if (index < ListOfIncomes.list.length)
      ListOfIncomes.list.insert(index, note);
    else
      ListOfIncomes.list.add(note);

    await Storage.saveString(jsonEncode(new ListOfIncomes().toJson()), 'IncomeNote');
    updateIncomesPage();
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
      sumByDay.add(sumByDayMode(i, incomesSortedByCategory));
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

  List<IncomeNote> getFilteredChildrenCategory(IncomeNote incomeNote) {
    List<IncomeNote> childrenList = ListOfIncomes.filtered(
        selMode: selectedMode,
        currentDate: date,
        currentCategory: incomeNote.category
    );

    childrenList.sort((a, b) => b.date.compareTo(a.date));
    return childrenList;
  }

  List<IncomeNote> getFilteredChildrenListByDay(int day) {
    List<IncomeNote> middleByDayList = ListOfIncomes.filtered(selMode: selectedMode, currentDate: date, day: day);

    List<IncomeNote> resultByDayList = List();

    for (int i = 0; i < middleByDayList.length; i++) {
      bool isFound = false;
      IncomeNote currentExpenseNote = middleByDayList[i];

      for (IncomeNote E in resultByDayList) {
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
      resultByDayList.add(
          IncomeNote(
              date: currentExpenseNote.date,
              category: currentExpenseNote.category,
              sum: sum,
              comment: currentExpenseNote.comment
          )
      );
    }
    return resultByDayList;
  }

  // list which expanded category by single notes
  ListView getExpandedChildrenForCategory(List<IncomeNote> middleList) {
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
                  Expanded(child: boolComment(middleList[index])),
                  SecondaryText(text: middleList[index].sum.toStringAsFixed(2)),
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
              int indexInListOfIncomes =
                  ListOfIncomes.list.indexOf(middleList[index]);
              CustomSnackBar.show(
                key: scaffoldKey,
                context: context,
                text: AppLocalizations.of(context)
                    .translate('Заметка удалена'),
                callBack: () {
                  undoDelete(middleList[index], indexInListOfIncomes);
                }
              );
              ListOfIncomes.list.remove(middleList[index]);
              await Storage.saveString(jsonEncode(new ListOfIncomes().toJson()), 'IncomeNote');
              widget.updateMainPage();
              updateIncomesPage();
            }
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: AppColors.edit,
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
      }
    );
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
      }
    );
  }

  boolComment(IncomeNote note) {
    if (note.comment == '' || note.comment == null) {
      return DateFormatText(
        dateTime: note.date,
        mode: 'Дата в строке',
        color: AppColors.textColor());
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateFormatText(
            dateTime: note.date,
            mode: 'Дата в строке',
            color: AppColors.textColor()),
          comment(note),
        ],
      );
    }
  }

  goToEditPage(BuildContext context, IncomeNote incomeNote) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return EditPageForIncomeCategory(
        updateIncomePage: updateIncomesPage,
        updateMainPage: widget.updateMainPage,
        note: incomeNote
      );
    }));
  }

  comment(IncomeNote note) {
    if (note.comment == null)
      return ThirdText('');
    else
      return ThirdText(note.comment);
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
              MainLocalText(text: 'Доход'),
              AppDropdownButton(page: 'income', selectedMode: selectedMode, updateSelMode: updateSelectedMode),
            ],
          ),
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
            incomesSortedByCategory.isEmpty ?
            Expanded(
              child: Center(child: MainLocalText(text: 'Доходов нет')))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainLocalText(text: 'Итого'),
                      MainRowText(
                          text: totalSum(incomesSortedByCategory).toStringAsFixed(2))
                    ],
                  ),
                ),
              ),
            selectedMode == 'Неделя(Д)' && incomesSortedByCategory.isNotEmpty
            ? Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ExpansionTileTheme(
                          child: ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SecondaryLocalText(text: toDateFormatDay(index + 1)),
                                SecondaryText(text: getSumByDayLIst(index + 1)),
                              ],
                            ),
                            backgroundColor: AppColors.backGroundColor(),
                            onExpansionChanged: (e) {},
                            children: [
                              Container(
                                height: _calcHeightOnChildrenListLength(getFilteredChildrenListByDay(Storage.langCode == 'en' ? index : index + 1)),
                                child: getExpandedChildrenForDay(getFilteredChildrenListByDay(Storage.langCode == 'en' ? index : index + 1)),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainLocalText(text: 'Среднее за неделю'),
                          MainRowText(text: getWeekAverage(incomesSortedByCategory))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
            : Expanded(
                child: ListView.builder(
                  itemCount: incomesSortedByCategory.length,
                  itemBuilder: (context, index) {
                    IncomeNote singleCategory = incomesSortedByCategory[index];
                    List<IncomeNote> childrenList = getFilteredChildrenCategory(singleCategory);

                    return Column(
                      children: [
                        ExpansionTileTheme(
                          child: ExpansionTile(
                            title: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SecondaryText(text: incomesSortedByCategory[index].category),
                                      SecondaryText(text: incomesSortedByCategory[index].sum.toStringAsFixed(2)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.backGroundColor(),
                            onExpansionChanged: (e) {},
                            children: [
                              Container(
                                height: _calcHeightOnChildrenListLength(childrenList),
                                child: getExpandedChildrenForCategory(childrenList),
                              )
                            ],
                          ),
                        ),
                      ],
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
