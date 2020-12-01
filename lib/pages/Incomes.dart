import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class Income extends StatefulWidget{
  final Function callback;
  Income({this.callback});

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  DateTime date = DateTime.now();
  DateTime oldDate;
  String selMode = 'Day';
  Size size;

  void initState(){
    loadIncomeList();
    super.initState();
  }

  void loadIncomeList() async {
    String m = await Storage.getString('IncomeNote');
    if(m != null){
      setState(() {
        ListOfIncome.fromJson(jsonDecode(m));
      });
    }
  }

  void r(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    List resultList = sumOfCategories();

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
        body: Column(
          children: [
            _getData(),
            resultList.isEmpty ?
            Align(
              child: CupertinoActivityIndicator(radius: 20),
              alignment: Alignment.center,
            ) :
            Expanded(
              child: ListView.builder(
                itemCount: ListOfIncome.list.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          // row of list creating function
                          _buildListItem(ListOfIncome.list[index]),
                          IconButton(
                              icon: Icon(
                                  Icons.delete
                              ),
                              color: MyColors.textColor,
                              onPressed: () async {
                                // remove note from the listOfIncome
                                ListOfIncome.list.removeAt(index);
                                // rewrite list to the file
                                await Storage.saveString(
                                    jsonEncode(new ListOfIncome().toJson()),
                                    'IncomeNote');
                                // setState function of main.dart
                                widget.callback();
                                // setState function of Income.dart
                                setState(() {});
                              }
                          )
                        ],
                      ),
                      Divider(color: MyColors.textColor),
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

  List sumOfCategories() {
    List middleList = List();
    for (int i = 0; i < ListOfIncome.list.length; i++) {
      if (_isInFilter(ListOfIncome.list[i].date))
        middleList.add(ListOfIncome.list[i]);
    }
    List resultList = List();
    for(int i= 0; i < middleList.length; i++){
      bool isFound = false;
      IncomeNote currentIncomeNote = middleList[i];

      for(IncomeNote I in resultList){
        if(currentIncomeNote.category == I.category){
          isFound = true;
          break;
        }
      }
      if(isFound) continue;

      double sum = middleList[i].sum;
      for (int j = i + 1; j < middleList.length; j++){
        if (currentIncomeNote.category == middleList[j].category)
          sum += middleList[j].sum;
      }
      resultList.add(IncomeNote(category: currentIncomeNote.category, sum: sum));
    }
    return resultList;
  }

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

  AppBar buildAppBar() {
    return AppBar(
        iconTheme: IconThemeData(
            color: MyColors.textColor
        ),
        backgroundColor: MyColors.mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText('Incomes'),
            buildDropdownButton(),
          ],
        ),
      );
  }

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

  buildDropdownButton() {
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
  // row of list creating function. creates row from list of income
  _buildListItem(IncomeNote value) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Container(
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
    );
  }
}


