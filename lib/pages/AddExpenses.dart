import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';


class AddExpenses extends StatelessWidget{
  String category;
  double sum;

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
          'Add Expenses',
          style: TextStyle(
            color: MyColors.textColor,
          ),
        ),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter category',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter category';
                }
                return null;
              },
              onChanged: (v) => category = v,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter sum',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter sum';
                }
                return null;
              },
              onChanged: (v) => sum = v as double,
            ),
            IconButton(
              iconSize: 35,
              icon: Icon(
                Icons.add_circle,
                color: MyColors.textColor,
              ),
              onPressed: (){
                Navigator.pop(context);
                _createExpenseNote(category, sum);
              },
            )
          ],
        ),
      ),
    );
  }
  _createExpenseNote(String category, double sum){
    ExpenseNote expenseNote = ExpenseNote(category, sum);
    ListOfExpenses.add(expenseNote);
  }
}

