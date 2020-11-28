import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class Income extends StatefulWidget{
  final Function callback;
  Income({this.callback});

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {

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

  void r(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
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
                    // row of list creating function
                    _buildListItem(ListOfIncome.list[index]),
                    IconButton(
                      icon: Icon(
                          Icons.delete
                      ),
                      color: MyColors.textColor,
                      onPressed: () async {
                        // remove note from the listOfIncome
                        ListOfIncome.list.removeAt(index);
                        // rewrite list to the file
                        await Storage.saveString(jsonEncode(new ListOfIncome().toJson()), 'IncomeNote');
                        // setState function of main.dart
                        widget.callback();
                        // setState function of Income.dart
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
    );
  }
}

// row of list creating function. creates row from list of income
_buildListItem(IncomeNote value) {
  return Padding(
    padding: EdgeInsets.only(left: 10),
    child: Container(
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
  );
}
