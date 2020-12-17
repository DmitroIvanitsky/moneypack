import 'dart:convert';
import 'package:flutter/material.dart';
import '../Objects/ExpenseNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Utility/Storage.dart';
import '../pages/ListOfExpensesCategories.dart';
import '../setting/MyColors.dart';
import '../setting/MainText.dart';

class EditPageForExpenseCategory extends StatefulWidget {
  final Function updateExpensePage;
  final Function updateMainPage;
  final ExpenseNote note;

  EditPageForExpenseCategory({
    this.updateExpensePage,
    this.updateMainPage,
    this.note
  });

  @override
  _EditPageForExpenseCategoryState createState() =>
      _EditPageForExpenseCategoryState(this.note);
}

class _EditPageForExpenseCategoryState extends State<EditPageForExpenseCategory> {
  ExpenseNote currentNote;

  _EditPageForExpenseCategoryState(this.currentNote);

  void updateCategory(String cat) {
    setState(() {
      currentNote.category = cat;
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
        color: MyColors.textColor,
      ),
      backgroundColor: MyColors.mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MainText("Редактирование"),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.done, color: MyColors.textColor),
            onPressed: (){
              updateListOfExpenses();
              widget.updateExpensePage();
              widget.updateMainPage();
              Navigator.pop(context);
            }
          ),
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
            getDateWidget(currentNote.date),
            Divider(),
            // category row
            GestureDetector(
              child: MainText(currentNote.category),
              onTap: () => onCategoryTap(context),
            ),
            Divider(),
            // sum row
            TextFormField(
              initialValue: currentNote.sum.toString(),
              decoration: const InputDecoration(
                hintText: 'Введите сумму',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Пожалуйста введите сумму';
                }
                return null;
              },
              onChanged: (v) => currentNote.sum = double.parse(v),
            ),
            TextFormField(
              initialValue: currentNote.comment,
              decoration: const InputDecoration(
                hintText: 'Введите коментарий',
              ),
              onChanged: (v) => currentNote.comment = v,
            ),
          ],
        ),
      ),
    );
  }

  updateListOfExpenses() async{
    int index = ListOfExpenses.list.indexOf(widget.note);
    ListOfExpenses.list[index] = currentNote;
    await Storage.saveString(jsonEncode(ListOfExpenses().toJson()), 'ExpenseNote');
  }

  onCategoryTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          return ListOfExpensesCategories(
            callback: updateCategory, 
            cat: currentNote.category
          );
        }
      )
    );
  }

  Widget getDateWidget(DateTime date) {
    return GestureDetector(
      onTap: onDateTap,
      child: (date != null)? MainText(
        date.toString().substring(0, 10),
        TextAlign.left,
      ) : MainText('Выберите дату'),
    );
  }

  onDateTap() async {
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
      currentNote.date = picked;
    });
  }

  theme(Widget child) {
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
