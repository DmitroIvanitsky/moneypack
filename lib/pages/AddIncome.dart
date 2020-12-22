import 'package:flutter/material.dart';
import '../setting/DateFormatText.dart';
import '../pages/Calculator.dart';
import '../Objects/IncomeNote.dart';
import '../Utility/Storage.dart';
import '../setting/MainRowText.dart';
import '../setting/MyColors.dart';
import '../pages/ListOfIncomesCategories.dart';

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
  List lastCategories = [];
  TextEditingController calcController = TextEditingController();

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    lastCategories = await Storage.getIncomeCategories();
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
        appBar: buildAppBar(),
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
                Divider(),
                FlatButton(
                  height: 50,
                  child: Row(
                    children: [
                      MainRowText(category),
                      Icon(Icons.arrow_drop_down, color: MyColors.textColor)
                    ],
                  ),
                  onPressed: () => onCategoryTap(context),
                ),
                Container(
                  height: 175,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: getLastCategories(),
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
        ),
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
          MainRowText('Добавить доход'),
          IconButton(
            iconSize: 35,
            icon: Icon(
              Icons.done,
              color: MyColors.textColor,
            ),
            onPressed: (){
              if (category == 'Выбирите категорию' || sum == null) return;
              Storage.saveIncomeNote(IncomeNote(date: date, category: category, sum: sum, comment: comment), category); // function to create note object
              widget.callback();
              Navigator.pop(context);
            },
          )
        ],
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
      onPressed: _onDateTap,
      child: (date != null)? DateFormatText(dateTime: date, mode: 'День')
          : MainRowText('Выберите дату'),
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

  onCategoryTap(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context){
              return ListOfIncomesCategories(callback: updateCategory, cat: category);
            }
        )
    );
  }

}
