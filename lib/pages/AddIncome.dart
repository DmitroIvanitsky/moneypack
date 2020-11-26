import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/pages/ListOfIncomeCategories.dart';

class AddIncome extends StatefulWidget{
  final Function callback;
  AddIncome({this.callback});

  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {

  DateTime date = DateTime.now();
  String category = '';
  double sum;
  List<String> _list = [];

  initList() async{
    _list = await Storage.getList('Income');
    _list == null || _list.isEmpty ? category = 'category' : category = _list[0];
    setState(() {});
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  void s(String cat){
    setState(() {
      category = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroudColor,
        appBar: buildAppBar(),
        body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                getDateWidget(),
                Divider(),
                GestureDetector(
                  child: MyText(category),
                  onTap: () => _onCategoryTap(context),
                ),
                Divider(),
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
                  onChanged: (v) => sum = double.parse(v),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
        iconTheme: IconThemeData(
          color: MyColors.textColor
        ),
        backgroundColor: MyColors.appBarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            MyText('Add Income'),
            IconButton(
              iconSize: 35,
              icon: Icon(
                  Icons.done,
                color: MyColors.textColor,
              ),
              onPressed: (){
                if (category == "category") return;
                _createIncomeNote(date, category, sum);
                widget.callback();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
  }

  Widget getDateWidget(){
    return GestureDetector(
      onTap: _onDateTap,
      child: (date != null)? MyText(
        date.toString().substring(0, 10),
        TextAlign.left,
      ) : MyText('select date'),
    );
  }

  _onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return _theme(child);
      },
    );
    setState(() {
      date = picked;
    });
  }

  _theme(Widget child){
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: MyColors.appBarColor,
          onPrimary: MyColors.textColor,
          surface: MyColors.appBarColor,
          onSurface: MyColors.textColor,
        ),
        dialogBackgroundColor: MyColors.backGroudColor,
      ),
      child: child,
    );
  }

  _onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfIncomeCategories(callback: s, cat: category);
            }
        )
    );
  }

  _createIncomeNote(DateTime date, String category, double sum) async{
    IncomeNote incomeNote = IncomeNote(date, category, sum);
    ListOfIncome.list.add(incomeNote);
    await Storage.saveString(jsonEncode(ListOfIncome().toJson()), 'IncomeNote');
  }
}
