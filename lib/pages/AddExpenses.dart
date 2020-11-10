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
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Scaffold(
        backgroundColor: MyColors.backGroudColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: MyColors.textColor
          ),
          backgroundColor: MyColors.appBarColor,
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
                  if (category == "category") return;
                  _createExpenseNote(date, category, sum);
                  widget.callBack();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    );
  }


  Widget getDateWidget(){
    return GestureDetector(
            onTap: _onDateTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: (date != null)? MyText(
                date.toString().substring(0, 10),
                TextAlign.left,
              ) : Text('please select date'),
            ),
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
          primary: Colors.cyan,
          onPrimary: MyColors.textColor,
          surface: Colors.cyan,
          onSurface: MyColors.textColor,
        ),
        dialogBackgroundColor: MyColors.backGroudColor,
        buttonColor: MyColors.textColor,
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

  _createExpenseNote(DateTime date, String category, double sum){
    ExpenseNote expenseNote = ExpenseNote(date, category, sum);
    ListOfExpenses.add(expenseNote);
  }
}

