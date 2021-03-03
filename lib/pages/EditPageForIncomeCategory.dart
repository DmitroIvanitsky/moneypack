import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_pack/setting/calendarTheme.dart';
import '../Utility/appLocalizations.dart';
import '../pages/Calculator.dart';
import '../setting/DateFormatText.dart';
import '../setting/MainLocalText.dart';
import '../setting/SecondaryLocalText.dart';
import '../widgets/rowWithButton.dart';
import '../widgets/rowWithWidgets.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfIncomes.dart';
import '../Utility/Storage.dart';
import '../pages/ListOfIncomesCategories.dart';
import '../setting/AppColors.dart';
import '../setting/MainRowText.dart';
import 'package:money_pack/setting/AppDecoration.dart';

class EditPageForIncomeCategory extends StatefulWidget {
  final Function updateIncomePage;
  final Function updateMainPage;
  final IncomeNote note;

  EditPageForIncomeCategory({
    this.updateIncomePage,
    this.updateMainPage,
    this.note
  });

  @override
  _EditPageForIncomeCategoryState createState() =>
      _EditPageForIncomeCategoryState(this.note);
}

class _EditPageForIncomeCategoryState extends State<EditPageForIncomeCategory> {
  IncomeNote currentNote;
  TextEditingController calcController;
  FocusNode sumFocusNode;
  FocusNode commentFocusNode;

  _EditPageForIncomeCategoryState(this.currentNote);

  @override
  void initState() {
    sumFocusNode = FocusNode();
    commentFocusNode = FocusNode();
    calcController = TextEditingController(text: currentNote.sum.toString());
    super.initState();
  }

  void updateCategory(String cat) {
    setState(() {
      currentNote.category = cat;
    });
  }

  void updateSum(double result){
    setState(() {
      if (calcController != null) calcController.text = result.toString();
      currentNote.sum = result;
    });
  }

  goToCalculator(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute <void>(
            builder: (BuildContext context) {
              return Calculator(updateSum: updateSum, result: currentNote.sum);
            }
        )
    );
  }

  updateListOfIncomes() async{
    int index = ListOfIncomes.list.indexOf(widget.note);
    ListOfIncomes.list[index] = currentNote;
    await Storage.saveString(jsonEncode(ListOfIncomes().toJson()), 'IncomeNote');
  }

  onCategoryTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfIncomesCategories(callback: updateCategory, cat: currentNote.category);
            }
        )
    );
  }

  Widget getDateWidget(DateTime date) {
    return FlatButton(
      onPressed: onDateTap,
      child: (date != null)? MainRowText(
        text: date.toString().substring(0, 10),
        align: TextAlign.left,
      ) : MainRowText(text: 'Выберите дату'),
    );
  }

  onDateTap() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return CalendarTheme.theme(child);
      },
    );
    setState(() {
      currentNote.date = picked;
    });
  }

  void dispose() {
    calcController.dispose();
    sumFocusNode.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.backGroundColor(),
          appBar: AppBar(
            shadowColor: AppColors.backGroundColor().withOpacity(.001),
            iconTheme: IconThemeData(color: AppColors.textColor(),),
            backgroundColor: AppColors.backGroundColor(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainLocalText(text: "Редактирование"),
                IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.done, color: AppColors.textColor()),
                    onPressed: (){
                      updateListOfIncomes();
                      widget.updateIncomePage();
                      widget.updateMainPage();
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: RowWithWidgets(
                        leftWidget: MainLocalText(text: 'Дата'),
                        rightWidget: (currentNote.date != null)?
                        DateFormatText(
                            dateTime: currentNote.date,
                            mode: 'Дата в строке'
                        )
                            : SecondaryLocalText(text: 'Выбирите дату'),
                        onTap: onDateTap
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: RowWithButton(
                      leftText: 'Категория',
                      rightText: currentNote.category,
                      onTap: () => onCategoryTap(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 60,
                          decoration: AppDecoration.boxDecoration(context),
                          width:  MediaQuery.of(context).size.width - 100,
                          child: TextFormField(
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(10),// for mobile
                            ],
                            onTap: () => sumFocusNode.requestFocus(),
                            focusNode: sumFocusNode,
                            keyboardType: TextInputType.number,
                            controller: calcController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                hintText: AppLocalizations.of(context).translate('Введите сумму'),
                                border: sumFocusNode.hasFocus ?
                                OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.blue)
                                ) : InputBorder.none
                            ),
                            onChanged: (v) => currentNote.sum = double.parse(v),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: AppDecoration.boxDecoration(context),
                          child: IconButton(
                              icon: Icon(
                                  Icons.calculate_outlined,
                                  color: AppColors.textColor(),
                                  size: 40
                              ),
                              onPressed: () => goToCalculator(context)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      decoration: AppDecoration.boxDecoration(context),
                      child: TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(20),// for mobile
                        ],
                        focusNode: commentFocusNode,
                        maxLines: 1,
                        initialValue: currentNote.comment,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate('Введите коментарий'),
                            contentPadding: EdgeInsets.all(20),
                            fillColor: Colors.white,
                            border: commentFocusNode.hasFocus ?
                            OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.blue)
                            ) : InputBorder.none
                        ),
                        onChanged: (v) => currentNote.comment = v,
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          )
      ),
    );
  }

}
