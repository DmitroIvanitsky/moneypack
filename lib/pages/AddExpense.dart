import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/SecondaryText.dart';
import 'package:flutter_tutorial/widgets/rowWithButton.dart';
import '../setting/DateFormatText.dart';
import '../Objects/ExpenseNote.dart';
import '../Utility/Storage.dart';
import '../pages/Calculator.dart';
import '../pages/ListOfExpensesCategories.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';

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
    lastCategories == null || lastCategories.isEmpty ?
      category = 'Выбирите категорию' : category = lastCategories.last;
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
          bottomNavigationBar: BottomAppBar(
            child: Container(
              decoration: BoxDecoration(
                  color: MyColors.mainColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5
                    )
                  ]
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context)
                  ),
                  MainRowText('Добавить расход'),
                  IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.done, color: MyColors.textColor),
                    onPressed: (){
                      if (category == 'Выбирите категорию' || sum == null) return; // to not add empty sum note
                      Storage.saveExpenseNote(
                          ExpenseNote(
                              date: date,
                              category: category,
                              sum: sum,
                              comment: comment),
                          category
                      ); // function to create note object
                      widget.callBack();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        //appBar: buildAppBar(),
        body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Row(children: [
                  getDateWidget(),
                  Icon(Icons.arrow_drop_down, color: MyColors.textColor)
                ],),
                Divider(color: MyColors.backGroundColor),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.backGroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      RowWithButton(
                        leftText: 'Категория',
                        rightText: category,
                        onTap: () =>
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListOfExpensesCategories(callback: updateCategory, cat: category)),
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
                Container(
                  height: 100,
                  child: IconButton(
                      icon: Icon(
                          Icons.calculate_outlined,
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
                    keyboardType: TextInputType.number,
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
          MainRowText('Добавить расход'),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.done, color: MyColors.textColor),
            onPressed: (){
              if (category == 'Выбирите категорию' || sum == null) return; // to not add empty sum note
              Storage.saveExpenseNote(
                  ExpenseNote(
                      date: date,
                      category: category,
                      sum: sum,
                      comment: comment),
                  category
              ); // function to create note object
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
    return FlatButton(
      onPressed: onDateTap,
      child: (date != null)? DateFormatText(dateTime: date, mode: 'Дата в строке')
          : SecondaryText('Выберите дату'),
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

