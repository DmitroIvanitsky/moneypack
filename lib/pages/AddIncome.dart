import 'package:flutter/material.dart';
import '../Utility/appLocalizations.dart';
import '../setting/MainLocalText.dart';
import '../setting/SecondaryLocalText.dart';
import '../widgets/rowWithButton.dart';
import '../widgets/rowWithWidgets.dart';
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
      if (calcController != null) calcController.text = result.toString();
      sum = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        //bottomNavigationBar: buildBottomAppBar(),
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBottomAppBar() {
    return BottomAppBar(
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
            MainLocalText(text: 'Добавить доход'),
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.done, color: MyColors.textColor),
              onPressed: (){
                if (category == AppLocalizations.of(context).translate('Выбирите категорию')
                    || sum == null
                ) return; // to not add empty sum note
                Storage.saveIncomeCategory(category);
                Storage.saveIncomeNote(
                  IncomeNote(
                    date: date,
                    category: category,
                    sum: sum,
                    comment: comment),
                  category
                ); // function to create note object
                widget.callback();
                Navigator.pop(context);
              },
            )
          ],
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
          MainLocalText(text: 'Добавить доход'),
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

  Widget buildBody() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 35),
              RowWithWidgets(
                  leftWidget: MainLocalText(text: 'Дата'),
                  rightWidget: (date != null)? DateFormatText(dateTime: date, mode: 'Дата в строке')
                      : SecondaryLocalText(text: 'Выбирите дату'),
                  onTap: onDateTap
              ),
              Divider(color: MyColors.backGroundColor),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.backGroundColor,
                    borderRadius: BorderRadius.circular(5),
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
                      height: 10,
                    ),
                    RowWithButton(
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => sumFocusNode.requestFocus(),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child:  TextFormField(
                              focusNode: sumFocusNode,
                              keyboardType: TextInputType.number,
                              controller: calcController,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context).translate('Введите сумму'),
                                  contentPadding: EdgeInsets.all(20.0),
                                  border: sumFocusNode.hasFocus
                                      ? OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: IconButton(
                        icon: Icon(
                            Icons.calculate_outlined,
                            color: MyColors.textColor,
                            size: 40
                        ),
                        onPressed: () => goToCalculator(context)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                focusNode: commentFocusNode,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('Введите коментарий'),
                    contentPadding: EdgeInsets.all(20.0),
                    fillColor: Colors.white,
                    border: commentFocusNode.hasFocus
                        ? OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)
                    ) : OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.grey)
                    )
                ),
                onChanged: (v) => comment = v,
              ),
            ],
          ),
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
