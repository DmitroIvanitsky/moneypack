import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class Expenses extends StatefulWidget{
  final Function callback;
  Expenses({this.callback});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime date = DateTime.now();
  DateTime oldDate;
  String selMode = 'Day';

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

  void r(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
//////////////////////////////////////////////////////////////////////////////////////
    List resultList = sumOfCategories();
///////////////////////////////////////////////////////////////////////////////////////
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: MyColors.textColor
          ),
          backgroundColor: MyColors.appBarColor,
          title: _buildDropdownButton() // dropdown menu button
        ),
        body: Column(
          children: [
            // data row in the top of the list
            _getData(),
            // indicator cupertino when list is empty
            //ListOfExpenses.list.isEmpty ?
            resultList.isEmpty ?
            Align(
              child: CupertinoActivityIndicator(radius: 20),
              alignment: Alignment.center,
            ) :
            // list of ExpenseNotes
            Expanded(
              child: ListView.builder(
                //itemCount: ListOfExpenses.list.length,
                itemCount: resultList.length,
                itemBuilder: (context, index){
                  //if (_isInFilter(ListOfExpenses.list[index].date))
                  //if (_isInFilter(resultList[index].date))
                  return Column(
                    children: [
                      Row(
                        children: [
                          // row of ExpenseNote
                          //_buildListItem(ListOfExpenses.list[index]), // function return row of ExpenseNote
                          _buildListItem(resultList[index]),
                          // delete row button
                          IconButton(
                            icon: Icon(
                                Icons.delete
                            ),
                            color: MyColors.textColor,
                            onPressed: () async {
                              ListOfExpenses.list.removeAt(index);
                              await Storage.saveString(jsonEncode(new ListOfExpenses().toJson()), 'ExpenseNote');
                              widget.callback();
                              setState(() {});
                            }
                          )
                        ],
                      ),
                      Divider(color: MyColors.textColor),
                    ],
                  );
                // else return Container();
                },
              ),
            ),
          ],
        ),
      ),
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
      resultList.add(ExpenseNote(category: currentExpenseNote.category, sum: sum));
    }
    return resultList;
  }

  // dropdown menu button
  _buildDropdownButton() {
    return DropdownButton(
        hint: MyText(selMode),
        items: [
          DropdownMenuItem(value: 'Day', child: MyText('Day')),
          DropdownMenuItem(value: 'Week', child: MyText('Week')),
          DropdownMenuItem(value: 'Month', child: MyText('Month')),
          DropdownMenuItem(value: 'Year', child: MyText('Year')),
        ],
        onChanged: (String newValue) {
          if (selMode != 'Week' && newValue == 'Week') {
            // oldDate = date;
            date = date.subtract(Duration(days: date.weekday + 1)).add(Duration(days: 7));
          }

          if (selMode == 'Week' && newValue != 'Week' && oldDate != null) {
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
      case 'Day' :
        return
            d.year == date.year &&
            d.month == date.month &&
            d.day == date.day;
        break;
      case 'Week':
        return
            d.year == date.year &&
            d.month == date.month &&
            d.isBefore(date) && d.isAfter(date.subtract(Duration(days: 7)));
            break;
      case 'Month' :
        return
            d.year == date.year &&
            d.month == date.month;
        break;
      case 'Year' :
        return
            d.year == date.year;
        break;
    }
  }

  // function return date with buttons
  _getData(){
    switch(selMode){
      case 'Day':
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
      case 'Week':
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
      case 'Month':
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
            MyText(date.month.toString()),
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
      case 'Year':
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

  // function return row of ExpenseNote
  _buildListItem(ExpenseNote value) {

    return Container(
      height: 50,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 340,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(value.category, TextAlign.start),
                  //SizedBox(width: 250),
                  MyText('${value.sum}', TextAlign.end),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




