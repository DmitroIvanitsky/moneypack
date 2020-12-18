import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/ListOfExpensesCategories.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MainText.dart';

class AddExpenses extends StatefulWidget{
  final Function callBack;
  AddExpenses({this.callBack});

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {

  DateTime date = DateTime.now();
  String category = '';
  double sum;
  String comment;
  List<String> _list = [];
  List lastCategories = [];

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    _list = await Storage.getList('Expenses');
    _list == null || _list.isEmpty ? category = 'Категория расхода' : category = _list.last;
    lastCategories = await Storage.getExpenseCategories();
    setState(() {});
  }

  void stateFunc(String cat){
    setState(() {
      category = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyColors.backGroundColor,
          appBar: buildAppBar(),
          body: buildBody(),
      ),
    );
  }

  List<Widget> getLastCategories(){
    if (lastCategories.length == null) return [Text('')];
    List<Widget> result = [];
    for (String catName in lastCategories) {
      result.add(
        RadioListTile<String>(
          title: Text(catName, style: TextStyle(color: catName == category? Colors.red : Colors.black),),
          groupValue: category,
          value: catName,
          onChanged: (String value) {
            setState(() {
              category = value;
            });
          },
        ),
      );
    }

    return result;
  }

  Widget buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainText('Добавить расход'),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.done, color: MyColors.textColor),
            onPressed: (){
              if (category == "category" || sum == null) return; // to not add empty sum note
              Storage.saveExpenseNote(ExpenseNote(date: date, category: category, sum: sum, comment: comment), category); // function to create note object
              widget.callBack();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // date widget row
            getDateWidget(),
            Divider(),
            // category row
            GestureDetector(
              child: MainText(category),
              onTap: () => onCategoryTap(context),
            ),
            Expanded(
              child: ListView(
                children: getLastCategories(),
              ),
            ),
            // RadioListTile<lastCategories>(
            //   title: const Text('Lafayette'),
            //   groupValue: category,
            //   value: 't',
            //   onChanged: (value) { setState(() { category = value; }); },
            // ),
            // RadioListTile<lastCategories>(
            //   title: const Text('Thomas Jefferson'),
            //   value: SingingCharacter.jefferson,
            //   groupValue: _character,
            //   onChanged: (String value) { setState(() { _character = value; }); },
            // ),
            Divider(),
            // sum row
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Введите сумму',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите сумму';
                }
                return null;
              },
              onChanged: (v) => sum = double.parse(v),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Введите коментарий',
              ),
              onChanged: (v) => comment = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget getDateWidget(){
    return GestureDetector(
      onTap: onDateTap,
      child: (date != null)? MainText(
        date.toString().substring(0, 10),
        TextAlign.left,
      ) : MainText('Выберите дату'),
    );
  }

  onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfExpensesCategories(callback: stateFunc, cat: category);
            }
        )
    );
  }

  onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return theme(child);
        },
    );
    setState(() {
      date = picked;
    });
  }

  theme(Widget child){
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: MyColors.mainColor,
          onPrimary: MyColors.textColor,
          surface: MyColors.mainColor,
          onSurface: MyColors.textColor,
        ),
        dialogBackgroundColor: MyColors.backGroundColor,
      ),
      child: child,
    );
  }

}

