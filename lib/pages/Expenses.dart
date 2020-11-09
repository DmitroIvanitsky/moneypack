import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';
import 'package:flutter_tutorial/setting/menu_icon.dart';

class Expenses extends StatefulWidget{
  final Function callback;
  Expenses({this.callback});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

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
      body: ListView.builder(
        itemCount: ListOfExpenses.list.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              Row(
                children: [
                  _buildListItem(ListOfExpenses.list[index]),
                  IconButton(
                      icon: Icon(
                          Icons.delete
                      ),
                      color: MyColors.textColor,
                      onPressed: () {
                        ListOfExpenses.list.removeAt(index);
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
    );
  }
}

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
