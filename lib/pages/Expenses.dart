import 'dart:convert';
import 'package:flutter/material.dart';
import '../setting/DateFormatText.dart';
import '../setting/ThirdText.dart';
import '../pages/EditPageForExpenseCategory.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';
import '../setting/SecondaryText.dart';

class Expenses extends StatefulWidget{
  final Function updateMainPage;

  Expenses({this.updateMainPage});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime date = DateTime.now();
  String selectedMode = 'День';

  @override
  void initState() {
    loadExpensesList();
    super.initState();
  }

  void loadExpensesList() async {
    String m = await Storage.getString('ExpenseNote');
    if(m != null) {
      setState(() {
        ListOfExpenses.fromJson(jsonDecode(m));
      });
    }
  }

  void updateExpensesPage(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainRowText('Расход'),
          _buildDropdownButton()
        ],
      ), // dropdown menu button
    );
  }

  Widget buildBody() {
    List categoriesList = filteredExpenses();

    return Column(
      children: [
        _getData(),
        categoriesList.isEmpty ?
        Align(
          child: MainRowText('Расходов нет'),
          alignment: Alignment.center,
        ) :
        Expanded(
          child: ListView.builder(
            itemCount: categoriesList.length,
            itemBuilder: (context, index){
              ExpenseNote singleCategory = categoriesList[index];
              List <ExpenseNote> childrenList = getFilteredChildrenOfCategory(singleCategory);

              return ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainRowText(singleCategory.category),
                      MainRowText('${singleCategory.sum}'),
                    ],
                  ),
                ),
                backgroundColor: MyColors.backGroundColor,
                onExpansionChanged: (e) {},
                children: [
                  Container(
                    height: _childrenListLength(childrenList),
                    //height: 200, // how to optimize height to max needed
                    child: getExpandedChildrenForCategory(childrenList),
                  )
                ],
              );
            }
          ),
        )
      ],
    );
  }

  double _childrenListLength(List list){
    double height;
    if (list.length >= 5){
      height = 250;
    }
    else{
      height = list.length.toDouble() * 50;
    }
    return height;
  }

  List filteredExpenses() {
    List middleList = List();
    for (int i = 0; i < ListOfExpenses.list.length; i++) {
      if (_isInFilter(ListOfExpenses.list[i].date))
        middleList.add(ListOfExpenses.list[i]);
    }
    List resultList = List();
    for(int i= 0; i < middleList.length; i++){
      bool isFound = false;
      ExpenseNote currentExpenseNote = middleList[i];

      for(ExpenseNote E in resultList){
        if(currentExpenseNote.category == E.category){
          isFound = true;
          break;
        }
      }
      if(isFound) continue;

      double sum = middleList[i].sum;
      for (int j = i + 1; j < middleList.length; j++){
        if (currentExpenseNote.category == middleList[j].category)
          sum += middleList[j].sum;
      }
      resultList.add(
        ExpenseNote(
          date: currentExpenseNote.date,
          category: currentExpenseNote.category,
          sum: sum,
          comment: currentExpenseNote.comment
        )
      );
    }
    return resultList;
  }

  List <ExpenseNote> getFilteredChildrenOfCategory (ExpenseNote expenseNote) {
    List <ExpenseNote> childrenList = [];
    for (int i = 0; i < ListOfExpenses.list.length; i++) {
      if (_isInFilter(ListOfExpenses.list[i].date) && ListOfExpenses.list[i].category == expenseNote.category)
        childrenList.add(ListOfExpenses.list[i]);
    }
    return childrenList;
  }

  // list which expanded category by single notes
  ListView getExpandedChildrenForCategory(List<ExpenseNote> middleList) {
    // ListView.getChildren and expanded to children
    return ListView.builder(
      itemCount: middleList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 21),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: boolComment(middleList, index),
                  ),
                  Row(
                    children: [
                      MainRowText('${middleList[index].sum}'),
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: MyColors.textColor,
                        onPressed: () => goToEditPage(
                          context,
                          middleList[index],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: MyColors.textColor,
                        onPressed: () async {
                          ListOfExpenses.list.remove(middleList[index]);
                          await Storage.saveString(jsonEncode(
                            new ListOfExpenses().toJson()), 'ExpenseNote');
                          widget.updateMainPage();
                          setState(() {});
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  boolComment(middleList, index) {
    if (middleList[index].comment == '' || middleList[index].comment == null){
      return DateFormatText(dateTime: date, mode: 'Дата в строке');
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateFormatText(dateTime: date, mode: 'Дата в строке'),
          comment(middleList, index),
        ],
      );
    }
  }

  goToEditPage(BuildContext context, ExpenseNote expenseNote){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context){
          return EditPageForExpenseCategory(
              updateExpensePage: updateExpensesPage,
              updateMainPage: widget.updateMainPage,
              note: expenseNote
          );
        })
    );
  }

  comment(List middleList, int index) {
      if (middleList[index].comment == null)
        return ThirdText('');
      else
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ThirdText(middleList[index].comment)
        );
  }

  // dropdown menu button
  _buildDropdownButton() {
        return DropdownButton(
            hint: MainRowText(selectedMode),
            items: [
              DropdownMenuItem(value: 'День', child: MainRowText('День')),
              DropdownMenuItem(value: 'Неделя', child: MainRowText('Неделя')),
              DropdownMenuItem(value: 'Месяц', child: MainRowText('Месяц')),
              DropdownMenuItem(value: 'Год', child: MainRowText('Год')),
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
            }
        );
      }

  // date filter function for list of expenses
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

  // function return date with buttons
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




