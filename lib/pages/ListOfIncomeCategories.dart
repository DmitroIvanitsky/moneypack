import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class ListOfIncomeCategories extends StatefulWidget{
  Function callback;
  String cat;
  ListOfIncomeCategories({this.callback, this.cat});

  @override
  _ListOfIncomeCategoriesState createState() => _ListOfIncomeCategoriesState();
}

class _ListOfIncomeCategoriesState extends State<ListOfIncomeCategories> {
  List<String> list = [
    'Salary',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        backgroundColor: MyColors.appBarColor,
        iconTheme: IconThemeData(
            color: MyColors.textColor
        ),
        title: MyText('Categories'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return Column(
            children: [
              GestureDetector(
                child: MyText(list[index]),
                onTap: (){
                  widget.callback(list[index]);
                  Navigator.pop(context);
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}