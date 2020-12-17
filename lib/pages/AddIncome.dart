import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Objects/IncomeNote.dart';
import 'package:flutter_tutorial/Objects/ListOfIncomes.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MainText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/pages/ListOfIncomesCategories.dart';

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
  String comment;
  List<String> _list = [];

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    _list = await Storage.getList('Income');
    _list == null || _list.isEmpty ? category = 'Категория дохода' : category = _list[0];
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

  Widget buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          MainText('Добавить доход'),
          IconButton(
            iconSize: 35,
            icon: Icon(
              Icons.done,
              color: MyColors.textColor,
            ),
            onPressed: (){
              if (category == "category" || sum == null) return;
              _createIncomeNote(date, category, sum, comment: comment);
              widget.callback();
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
          children: <Widget>[
            SizedBox(height: 10),
            getDateWidget(),
            Divider(),
            GestureDetector(
              child: MainText(category),
              onTap: () => _onCategoryTap(context),
            ),
            Divider(),
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
      onTap: _onDateTap,
      child: (date != null)? MainText(
        date.toString().substring(0, 10),
        TextAlign.left,
      ) : MainText('Выберите дату'),
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

  _onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfIncomesCategories(callback: stateFunc, cat: category);
            }
        )
    );
  }

  _createIncomeNote(DateTime date, String category, double sum, {String comment}) async{
    IncomeNote incomeNote = IncomeNote(date: date, category: category, sum: sum, comment: comment);
    ListOfIncomes.list.add(incomeNote);
    await Storage.saveString(jsonEncode(ListOfIncomes().toJson()), 'IncomeNote');
  }

}
