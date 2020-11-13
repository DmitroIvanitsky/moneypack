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
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: MyColors.textColor
        ),
        backgroundColor: MyColors.appBarColor,
        title: Text(
          'Expenses',
          style: TextStyle(
            color: MyColors.textColor,
          ),
        ),
      ),
      body: Column(
        children: [
// data row in the top of the list
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () => null,
              ),
              MyText(date.toString().substring(0, 10)),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => null,
              ),
            ],
          ),
// indicator
          ListOfExpenses.list.isEmpty ?
          Align(
            child: CupertinoActivityIndicator(radius: 20),
            alignment: Alignment.center,
          ) :
// list of ExpenseNotes
          Expanded(
            child: ListView.builder(
              itemCount: ListOfExpenses.list.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Row(
                      children: [
// row of ExpenseNote
                        _buildListItem(ListOfExpenses.list[index]), // function return row of ExpenseNote
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
              },
            ),
          ),
        ],
      ),
    );
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




