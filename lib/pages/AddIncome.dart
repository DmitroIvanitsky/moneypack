import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncome.dart';
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
  String category = 'category';
  double sum;

  void s(String cat){
    setState(() {
      category = cat;
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
                _createIncomeNote(date, category, sum);
                widget.callback();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                child: MyText(
                  date.toString().substring(0, 10),
                  TextAlign.left,
                ),
                onTap: _onDateTap
            ),
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

  _onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
    );
    setState(() {
      date = picked;
    });
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

  _createIncomeNote(DateTime date, String category, double sum){
    IncomeNote incomeNote = IncomeNote(date, category, sum);
    ListOfIncome.add(incomeNote);
  }
}
