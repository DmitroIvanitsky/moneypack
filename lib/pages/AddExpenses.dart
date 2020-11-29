import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/ListOfExpensesCategories.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

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
  List<String> _list = [];

  initList() async{
    _list = await Storage.getList('Expenses');
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
          backgroundColor: MyColors.backGroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: MyColors.textColor
            ),
            backgroundColor: MyColors.mainColor2,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('Add Expenses'),
                IconButton(
                  iconSize: 35,
                  icon: Icon(
                    Icons.done,
                    color: MyColors.textColor,
                  ),
                  onPressed: (){
                    // to not add empty sum note
                    if (category == "category" || sum == null) return;
                    // function to create note object
                    _createExpenseNote(date, category, sum);
                    widget.callBack();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          body: Padding(
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
                    child: MyText(category),
                    onTap: () => _onCategoryTap(context),
                  ),
                  Divider(),
                  // sum row
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
          primary: MyColors.mainColor2,
          onPrimary: MyColors.textColor,
          surface: MyColors.mainColor2,
          onSurface: MyColors.textColor,
        ),
        dialogBackgroundColor: MyColors.backGroundColor,
      ),
      child: child,
    );
  }

  _onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfExpensesCategories(callback: s, cat: category);
            }
        )
    );
  }

  _createExpenseNote(DateTime date, String category, double sum) async{
    ExpenseNote expenseNote = ExpenseNote(date: date, category: category, sum: sum);
    ListOfExpenses.list.add(expenseNote);
    await Storage.saveString(jsonEncode(ListOfExpenses().toJson()), 'ExpenseNote');

    // String m = await Storage.getString('ExpenseNote');
    // ListOfExpenses lx = ListOfExpenses.fromJson(jsonDecode(m));
    // print(ListOfExpenses.list[0]);
  }
}

