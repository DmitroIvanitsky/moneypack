import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'file:///C:/Users/nic-pc/Desktop/projects/flutter_tutorial/lib/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class Expenses extends StatefulWidget{
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
          if(index.isOdd) return Divider();
          return _buildListItem(ListOfExpenses.list[index]);
        },
      ),
    );
  }
}

 _buildListItem(ExpenseNote value) {
  return Row(
    children: [
          MyText(value.category, TextAlign.start),
          // SizedBox(
          //   width: double.infinity,
          // ),
          MyText('${value.sum}', TextAlign.end),
      ],
  );
}
