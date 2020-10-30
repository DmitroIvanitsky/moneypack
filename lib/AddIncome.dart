import 'package:flutter/material.dart';
import 'package:flutter_tutorial/ExpenseNote.dart';
import 'package:flutter_tutorial/ListOfExpenses.dart';
import 'package:flutter_tutorial/MyStatefulWidget.dart';
import 'package:flutter_tutorial/MyText.dart';
import 'package:flutter_tutorial/MyColors.dart';

class AddIncome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.textColor
        ),
        backgroundColor: MyColors.appBarColor,
        title: Row(
          children:[
            MyText('Add Income'),
            SizedBox(width: 160),
            IconButton(
                iconSize: 35,
                icon: Icon(
                  Icons.add_circle,
                  color: MyColors.textColor,
                ),
                //onPressed: () => _createExpenseNote(category, sum),
              onPressed: null,
            )
          ],
        ),
      ),
      body: MyStatefulWidget(),
    );
  }

  _createExpenseNote(String category, double sum){
    ExpenseNote expenseNote = ExpenseNote(category, sum);
    //ListOfExpenses.add(expenseNote);
  }
}