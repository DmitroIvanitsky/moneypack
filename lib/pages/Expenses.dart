import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
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
          //if(index.isOdd)
            //return Divider(color: MyColors.textColor);
          //final int i = index ~/ 2;
          return Column(
            children: [
              _buildListItem(ListOfExpenses.list[index]),
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              MyText(value.category, TextAlign.start),
              MyText('${value.sum}', TextAlign.end),
              IconButton(
                icon: Icon(Icons.arrow_drop_down_circle_outlined),
                onPressed: null,
              ),
          ],
      ),
    ),
  );
}
