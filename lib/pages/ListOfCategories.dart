import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class ListOfCategories extends StatefulWidget{
  Function callback;
  String cat;
  ListOfCategories({this.callback, this.cat});

  @override
  _ListOfCategoriesState createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  List<String> list = [
    'car',
    'food',
    'phone',
    'internet'
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