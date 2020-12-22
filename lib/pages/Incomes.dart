import 'dart:convert';
import 'package:flutter/material.dart';
import '../setting/DateFormatText.dart';
import '../setting/SecondaryText.dart';
import '../setting/ThirdText.dart';
import '../pages/EditPageForIncomeCategory.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfIncomes.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';

class Incomes extends StatefulWidget{
  final Function updateMainPage;

  Incomes({this.updateMainPage});

  @override
  _IncomesState createState() => _IncomesState();
}

class _IncomesState extends State<Incomes> {
  DateTime date = DateTime.now();
  String selectedMode = 'День';

  @override
  void initState(){
    loadIncomeList();
    super.initState();
  }

  void loadIncomeList() async {
    String m = await Storage.getString('IncomeNote');
    if(m != null){
      setState(() {
        ListOfIncomes.fromJson(jsonDecode(m));
      });
    }
  }

  void updateIncomesPage(){
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
          MainRowText('Доход'),
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
          child: MainRowText('Доходов нет'),
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
                              MainRowText(categoriesList[index].category),
                              MainRowText('${categoriesList[index].sum}'),
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
    for (int i = 0; i < ListOfIncomes.list.length; i++) {
      if (_isInFilter(ListOfIncomes.list[i].date))
        middleList.add(ListOfIncomes.list[i]);
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
    for (int i = 0; i < ListOfIncomes.list.length; i++){
      if (_isInFilter(ListOfIncomes.list[i].date) && ListOfIncomes.list[i].category == incomeNote.category)
        childrenList.add(ListOfIncomes.list[i]);
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
                  boolComment(middleList, index),
                  Row(
                    children: [
                      MainRowText("${middleList[index].sum}"),
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
                          ListOfIncomes.list.remove(middleList[index]);
                          await Storage.saveString(jsonEncode(
                            new ListOfIncomes().toJson()), 'IncomeNote');
                          widget.updateMainPage();
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

  goToEditPage(BuildContext context, IncomeNote incomeNote){
    Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context){
        return EditPageForIncomeCategory(
          updateIncomePage: updateIncomesPage,
          updateMainPage: widget.updateMainPage,
          note: incomeNote);
      })
    );
  }

  comment(middleList, index){
    if (middleList[index].comment == null)
      return ThirdText('');
    else
      return ThirdText(middleList[index].comment);
  }

  buildDropdownButton() {
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


