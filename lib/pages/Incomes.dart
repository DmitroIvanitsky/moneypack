import 'dart:convert';
import 'package:flutter/material.dart';
import '../pages/EditPageForIncomeCategory.dart';
import '../Utility/appLocalizations.dart';
import 'package:intl/intl.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfIncome.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../setting/MyText.dart';

class Incomes extends StatefulWidget{
  final Function callback;
  Incomes({this.callback});

  @override
  _IncomesState createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {
  DateTime date = DateTime.now();
  DateTime oldDate;
  String selMode = 'День';

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

  void updateData(){
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
          MyText('Доход'),
          buildDropdownButton(),
        ],
      ),
    );
  }

  Widget buildBody(){
    List categoriesList = filteredIncomes();

    return Column(
      children: [
        _getData(),
        categoriesList.isEmpty ?
        Align(
          child: MyText('Доходов нет'),
          alignment: Alignment.center,
        ) :
        Expanded(
          child: ListView.builder(
            itemCount: categoriesList.length,
            itemBuilder: (context, index){
              IncomeNote singleCategory = categoriesList[index];
              List <IncomeNote> childrenList = getFilteredChildrenCategory(singleCategory);

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
                              MyText(categoriesList[index].category),
                              MyText('${categoriesList[index].sum}'),
                            ],
                          ),
                        ),
                        //Divider(color: MyColors.textColor),
                      ],
                    ),
                    backgroundColor: MyColors.backGroundColor,
                    onExpansionChanged: (e) {},
                    children: [
                      Container(
                        height: childrenList.length * 50.0,
                        //height: 200, // how to optimize height to max needed
                        child: getExpandedChildrenForCategory(childrenList),
                      )
                    ],
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }

  List filteredIncomes() {
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
      resultList.add(
          IncomeNote(
            date: currentIncomeNote.date,
            category: currentIncomeNote.category,
            sum: sum,
            comment: currentIncomeNote.comment
          )
      );
    }
    return resultList;
  }

  List <IncomeNote> getFilteredChildrenCategory(IncomeNote incomeNote){
    List <IncomeNote> childrenList = [];
    for (int i = 0; i < ListOfIncome.list.length; i++){
      if (_isInFilter(ListOfIncome.list[i].date) && ListOfIncome.list[i].category == incomeNote.category)
        childrenList.add(ListOfIncome.list[i]);
    }
    return childrenList;
  }

  // list which expanded category by single notes
  ListView getExpandedChildrenForCategory(List <IncomeNote> middleList){
    // ListView.getChildren and expanded to children
    return ListView.builder(
      itemCount: middleList.length,
      itemBuilder: (context, index){
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
                      MyText("${middleList[index].sum}"),
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
                          ListOfIncome.list.removeAt(index);
                          await Storage.saveString(jsonEncode(
                            new ListOfIncome().toJson()), 'IncomeNote');
                          widget.callback();
                          setState(() {});
                        },
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

  goToEditPage(BuildContext context, IncomeNote incomeNote){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context){
          return EditPage(callback: updateData, note: incomeNote);
        }));
  }

  comment(middleList, index){
    if (middleList[index].comment == null)
      return MyText('');
    else
      return MyText(middleList[index].comment);
  }

  buildDropdownButton() {
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


