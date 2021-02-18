import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_pack/setting/ThirdText.dart';
import '../Utility/appLocalizations.dart';
import '../setting/MainLocalText.dart';
import '../setting/SecondaryLocalText.dart';
import '../widgets/rowWithButton.dart';
import '../widgets/rowWithWidgets.dart';
import '../setting/DateFormatText.dart';
import '../pages/Calculator.dart';
import '../Objects/IncomeNote.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../pages/ListOfIncomesCategories.dart';

class AddIncome extends StatefulWidget{
  final Function callback;
  AddIncome({this.callback});

  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {

  DateTime date = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String category = '';
  double sum;
  String comment;
  List lastCategories = [];
  TextEditingController calcController = TextEditingController();
  FocusNode sumFocusNode;
  FocusNode commentFocusNode;

  @override
  void initState() {
    sumFocusNode = FocusNode();
    commentFocusNode = FocusNode();
    initList();
    super.initState();
  }

  void dispose() {
    calcController.dispose();
    sumFocusNode.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  initList() async{
    lastCategories = await Storage.getIncomeCategories();
    lastCategories == null || lastCategories.isEmpty ?
      category = AppLocalizations.of(context).translate('Выбирите категорию') :
        category = lastCategories.last;
    setState(() {});
  }

  void updateCategory(String cat){
    setState(() {
      category = cat;
    });
  }

  void updateSum(double result){
    setState(() {
      if (calcController != null) calcController.text = result.toStringAsFixed(2);
      sum = result;
    });
  }

  List<Widget> getLastCategories(){
    if (lastCategories == null || lastCategories.length == 0) return [Text('')]; // TO DEBUG null in process
    List<Widget> result = [];
    for (String catName in lastCategories) {
      result.add(
        RadioListTile<String>(
          title: ThirdText(catName,),
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

  onDateTap() async{
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
          onPrimary: MyColors.textColor2,
          surface: MyColors.mainColor,
          onSurface: MyColors.textColor2,
        ),
        dialogBackgroundColor: MyColors.backGroundColor,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyColors.textColor2),
          shadowColor: MyColors.backGroundColor.withOpacity(.001),
          backgroundColor: MyColors.backGroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              MainLocalText(text: 'Добавить доход'),
              IconButton(
                iconSize: 35,
                icon: Icon(
                  Icons.done,
                  color: MyColors.textColor2,
                ),
                onPressed: (){
                  if (category == 'Выбирите категорию' ||
                      category == 'Choose category' ||
                      category == 'Оберіть категорію' ||
                      sum == null) return;
                  Storage.saveIncomeNote(IncomeNote(date: date, category: category, sum: sum, comment: comment), category); // function to create note object
                  widget.callback();
                  Navigator.pop(context);
                },
              )
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
                  padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                  child: RowWithWidgets(
                      leftWidget: MainLocalText(text: 'Дата'),
                      rightWidget: (date != null)
                          ? DateFormatText(dateTime: date, mode: 'Дата в строке')
                          : SecondaryLocalText(text: 'Выбирите дату'),
                      onTap: onDateTap
                  ),
                ),
                Container(
                  decoration: MyColors.boxDecoration,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: RowWithButton(
                          leftText: 'Категория',
                          rightText: category,
                          onTap: () =>
                              Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => ListOfIncomesCategories(
                                        callback: updateCategory,
                                        cat: category
                                    )
                                ),
                              ),
                        ),
                      ),
                      Container(
                        height: 175,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: getLastCategories(),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        decoration: MyColors.boxDecoration,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => sumFocusNode.requestFocus(),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child:  TextFormField(
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(10),// for mobile
                                  ],
                                  style: TextStyle(color: MyColors.textColor2),
                                  focusNode: sumFocusNode,
                                  keyboardType: TextInputType.number,
                                  controller: calcController,
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context).translate('Введите сумму'),
                                      contentPadding: EdgeInsets.all(20.0),
                                      border: sumFocusNode.hasFocus
                                          ? OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          borderSide: BorderSide(color: Colors.blue)
                                      ) : InputBorder.none
                                  ),
                                  onChanged: (v) => sum = double.parse(v),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: MyColors.boxDecoration,
                        child: IconButton(
                            icon: Icon(
                                Icons.calculate_outlined,
                                color: MyColors.textColor2,
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
                    decoration: MyColors.boxDecoration,
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),// for mobile
                      ],
                      style: TextStyle(color: MyColors.textColor2),
                      focusNode: commentFocusNode,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate('Введите коментарий'),
                          contentPadding: EdgeInsets.all(20.0),
                          fillColor: Colors.white,
                          border: commentFocusNode.hasFocus
                              ? OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)
                          ) : InputBorder.none,
                      ),
                      onChanged: (v) => comment = v,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
