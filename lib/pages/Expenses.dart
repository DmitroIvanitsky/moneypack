import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Utility/appLocalizations.dart';
import 'package:intl/intl.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../setting/MyText.dart';
import '../setting/menu_icon.dart';

class Expenses extends StatefulWidget{
  final Function callback;
  Expenses({this.callback});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime date = DateTime.now();
  DateTime oldDate;
  String selMode = 'День';

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

  void stateFunc(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    List resultList = sumOfCategories();
    // for (int y = 0; y < resultList.length; y++){
    //   print('${resultList[y].sum} ${resultList[y].comment}');
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
        body: buildBody(resultList),
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
          MyText('Расход'),
          _buildDropdownButton()
        ],
      ), // dropdown menu button
    );
  }

  Widget buildBody(List resultList) {
    return Column(
      children: [
        // data row in the top of the list
        _getData(),
        resultList.isEmpty ?
        Align(
          child: MyText('Расходов нет'),
          alignment: Alignment.center,
        ) :
        Expanded(
          child: ListView.builder(
            itemCount: resultList.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  ExpansionTile(
                    title: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(resultList[index].category),
                              MyText('${resultList[index].sum}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: MyColors.backGroundColor,
                    onExpansionChanged: (e) {},
                    children: [
                      Container(
                        height: double.maxFinite,
                        //height: 200, // how to optimize height to max needed
                        child: expandedCategory(resultList[index].category),
                      )
                    ],
                  ),
                ],
              );
            }
          ),
        )
      ],
    );
  }

  List sumOfCategories() {
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
          category: currentExpenseNote.category,
          sum: sum,
          date: currentExpenseNote.date,
          comment: currentExpenseNote.comment
        )
      );
    }
    return resultList;
  }

  // list which expanded category by single notes
  ListView expandedCategory(String category) {
    List middleList = List();
    for (int i = 0; i < ListOfExpenses.list.length; i++) {
      if (_isInFilter(ListOfExpenses.list[i].date) && ListOfExpenses.list[i].category == category)
        middleList.add(ListOfExpenses.list[i]);
    }
    /// ListView.getChildren and expanded to children
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
                    MyText(middleList[index].category),
                    comment(middleList, index),
                    Row(
                      children: [
                        MyText('${middleList[index].sum}'),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: MyColors.textColor,
                          onPressed: () async {
                            ListOfExpenses.list.removeAt(index);
                            await Storage.saveString(jsonEncode(
                                new ListOfExpenses().toJson()),
                                'ExpenseNote');
                            widget.callback();
                            setState(() {});
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Divider(color: MyColors.textColor),
            ],
          );
        }
    );
  }

  comment(List middleList, int index) {
      if (middleList[index].comment == null)
        return MyText('');
      else
        return MyText(middleList[index].comment);
  }

  // dropdown menu button
  _buildDropdownButton() {
        return DropdownButton(
            hint: MyText(selMode),
            items: [
              DropdownMenuItem(value: 'День', child: MyText('День')),
              DropdownMenuItem(value: 'Неделя', child: MyText('Неделя')),
              DropdownMenuItem(value: 'Месяц', child: MyText('Месяц')),
              DropdownMenuItem(value: 'Год', child: MyText('Год')),
            ],
            onChanged: (String newValue) {
              if (selMode != 'Неделя' && newValue == 'Неделя') {
                // oldDate = date;
                date = date.subtract(Duration(days: date.weekday + 1)).add(Duration(days: 7));
              }

              if (selMode == 'Неделя' && newValue != 'Неделя' && oldDate != null) {
                //date = oldDate;
                date = DateTime.now();
              }

              setState(() {
                selMode = newValue;
              });
            }
        );
      }

  // date filter function for list of expenses
  _isInFilter(DateTime d){
    if (d == null) return false;

    switch (selMode) {
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
    switch(selMode){
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
            MyText(date.toString().substring(0, 10)),
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
            Row(
              children: [
                MyText(date.subtract(Duration(days: 6)).toString().substring(0, 10) + ' - '),
                MyText(date.toString().substring(0, 10)),
              ],
            ),
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
            MyText(AppLocalizations.of(context).translate(DateFormat.MMMM().format(date))+ ' '
                + DateFormat.y().format(date)),
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
            MyText(date.year.toString()),
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




