import 'dart:convert';
import 'package:flutter/material.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfIncome.dart';
import '../Utility/Storage.dart';
import '../pages/ListOfIncomeCategories.dart';
import '../setting/MyColors.dart';
import '../setting/MyText.dart';

class EditPage extends StatefulWidget {
  final Function callback;
  final IncomeNote note;

  EditPage({this.callback, this.note});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  DateTime date;
  String category;
  double sum;
  String comment;
  int oldIndex;
  int newIndex;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData(){
    date = widget.note.date;
    category = widget.note.category;
    sum = widget.note.sum;
    comment = widget.note.comment;
    oldIndex = ListOfIncome.list.indexOf(widget.note);
  }

  void updateData(String cat){
    if (category != cat)
      setState(() {
        category = cat;
        newIndex = -1;
      });
    else
    setState(() {
      category = cat;
      newIndex = oldIndex;
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

  Widget buildAppBar(){
    return AppBar(
      iconTheme: IconThemeData(
        color: MyColors.textColor,
      ),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(widget.note.category),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.done, color: MyColors.textColor),
            onPressed: (){
              editNote(oldIndex, newIndex, date, category, sum, comment: comment);
              widget.callback();
              Navigator.pop(context);
            }
          ),
        ],
      ),
    );
  }

  editNote(int oldIndex, int newIndex, DateTime date, String category, double sum, {String comment}) async{
    IncomeNote newIncomeNote = IncomeNote(date: date, category: category, sum: sum, comment: comment);
    if (newIndex != -1) {
      ListOfIncome.list.removeAt(oldIndex);
      ListOfIncome.list.insert(oldIndex, newIncomeNote);
      await Storage.saveString(
          jsonEncode(ListOfIncome().toJson()), 'IncomeNote');
    }
    else{
      ListOfIncome.list.removeAt(oldIndex);
      ListOfIncome.list.add(newIncomeNote);
      await Storage.saveString(jsonEncode(ListOfIncome().toJson()), 'IncomeNote');
    }
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
            getDateWidget(date),
            Divider(),
            // category row
            GestureDetector(
              child: MyText(category),
              onTap: () => onCategoryTap(context),
            ),
            Divider(),
            // sum row
            TextFormField(
              initialValue: sum.toString(),
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
              initialValue: comment,
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

  Widget getDateWidget(DateTime date){
    return GestureDetector(
      onTap: onDateTap,
      child: (date != null)? MyText(
        date.toString().substring(0, 10),
        TextAlign.left,
      ) : MyText('Выберите дату'),
    );
  }

  onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfIncomeCategories(callback: updateData, cat: category);
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

}
