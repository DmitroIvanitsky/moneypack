import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class Income extends StatefulWidget{
  final Function callback;
  Income({this.callback});

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {

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
          'Income',
          style: TextStyle(
            color: MyColors.textColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: ListOfIncome.list.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              Row(
                children: [
                  _buildListItem(ListOfIncome.list[index]),
                  IconButton(
                      icon: Icon(
                          Icons.delete
                      ),
                      color: MyColors.textColor,
                      onPressed: () {
                        ListOfIncome.list.removeAt(index);
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

_buildListItem(IncomeNote value) {
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
