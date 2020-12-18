import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Utility/Storage.dart';
import '../pages/Calculator.dart';
import '../pages/ListOfExpensesCategories.dart';
import '../setting/MyColors.dart';
import '../setting/MainText.dart';

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
  List lastCategories = [];
  TextEditingController calcController = TextEditingController();

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    lastCategories = await Storage.getExpenseCategories();
    lastCategories == null || lastCategories.isEmpty ? category = 'Категория расхода' : category = lastCategories.last;
    setState(() {});
  }

  void updateCategory(String cat){
    setState(() {
      category = cat;
    });
  }

  void updateSum(double result){
    setState(() {
      if (calcController != null) calcController.text = result.toString();
      sum = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyColors.backGroundColor,
          appBar: buildAppBar(),
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  // date widget row
                  getDateWidget(),
                  Divider(),
                  // category row
                  Container(
                    height: 75,
                    child: GestureDetector(
                      child: Row(
                        children: [
                          MainText(category),
                          Icon(Icons.arrow_drop_down, color: MyColors.textColor)
                        ],
                      ),
                      onTap: () => onCategoryTap(context),
                    ),
                  ),
                  Container(
                    height: 175,
                    child: ListView(
                      children: getLastCategories(),
                    ),
                  ),
                  Container(
                    height: 75,
                    child: IconButton(
                        icon: Icon(
                            Icons.call_to_action,
                            color: MyColors.textColor,
                            size: 40
                        ),
                        onPressed: () => goToCalculator(context)
                    ),
                  ),
                  // sum row
                  Container(
                    height: 75,
                    child: TextFormField(
                      controller: calcController,
                      decoration: const InputDecoration(
                        hintText: 'Введите сумму',
                      ),
                      onChanged: (v) => sum = double.parse(v),
                    ),
                  ),
                  Container(
                    height: 75,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Введите коментарий',
                      ),
                      onChanged: (v) => comment = v,
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  List<Widget> getLastCategories(){
    if (lastCategories == null || lastCategories.length == 0) return [Text('')]; // TO DEBUG null in process
    List<Widget> result = [];
    for (String catName in lastCategories) {
      result.add(
        RadioListTile<String>(
          title: Text(
            catName,
            style: TextStyle(
                fontWeight: catName == category? FontWeight.bold : FontWeight.normal
            ),
          ),
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


  initialValue(){
    if(sum != null)
      return sum.toString();
    else
      return;
  }

  goToCalculator(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute <void>(
            builder: (BuildContext context) {
              return Calculator(updateSum: updateSum, result: sum);
            }
        )
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
              return ListOfExpensesCategories(callback: updateCategory, cat: category);
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

