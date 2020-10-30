import 'package:flutter/material.dart';
import 'package:flutter_tutorial/MyColors.dart';
import 'ExpenseNote.dart';

class Expenses extends StatefulWidget{
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

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
      body: Row(
        children: [
          Text(ListOfExpenses.print())
        ],
      ),
    );
    setState(() {
    });
  }
}

class ListOfExpenses {
  static List<ExpenseNote> list = List();

  static add(ExpenseNote item) {
    list.add(item);
  }

  static print(){
    for(var n in list){
      return n.toString();
    }
  }
}