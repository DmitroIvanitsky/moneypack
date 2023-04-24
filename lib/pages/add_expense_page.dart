import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Objects/record.dart';
import '../decorations/app_decorations.dart';
import '../decorations/calendar_theme.dart';
import '../Utility/app_localizations.dart';
import '../interfaces/expense_service_interface.dart';
import '../services/navigator_service.dart';
import '../widgets/large_local_text.dart';
import '../widgets/small_text.dart';
import '../widgets/row_with_button.dart';
import '../widgets/row_with_widgets.dart';
import '../widgets/date_format_text.dart';
import '../constants/app_colors.dart';

class AddExpensesPage extends StatefulWidget{
  AddExpensesPage({this.expenseService, this.navigatorService});

  final ExpenseServiceInterface expenseService;
  final NavigatorService navigatorService;

  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
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
    super.initState();
  }

  @override
  void didChangeDependencies(){
    loadAllData();
    super.didChangeDependencies();
  }

  void dispose() {
    calcController.dispose();
    sumFocusNode.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  loadAllData() async{
    lastCategories = await widget.expenseService.readExpenseCategories();
    lastCategories == null || lastCategories.isEmpty ?
      category = AppLocalizations.of(context).translate('Choose category')
        : category = lastCategories.last;
    setState(() {});
  }

  void updateCategory(String cat){
    setState(() {
      category = cat;
    });
  }

  List<Widget> getLastCategories(){
    if (lastCategories.isEmpty)
      return [Text('')];

    List<Widget> result = [];
    for (String catName in lastCategories) {
      result.add(
        RadioListTile<String>(
          activeColor: Theme.of(context).textTheme.displayLarge.color,
          title: ThirdText(catName,),
          groupValue: category,
          value: catName,
          onChanged: (String value) {
            updateCategory(value);
          },
        ),
      );
    }
    return result;
  }

  initialValue(){
    if(sum != null)
      return sum.toString();
    else
      return;
  }

  goToCalculator(BuildContext context) async {
    double result = await widget.navigatorService.navigateCalculator(
        context: context,
        amount: sum
    );

    if (calcController != null) calcController.text = result.toStringAsFixed(2);
    setState(() {
      sum = result;
    });
  }

  onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
          return CalendarTheme.theme(child, context);
        },
    );
    if (picked != null)
      setState(() {
        date = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainLocalText(text: 'Add Expense'),
              IconButton(
                iconSize: 35,
                icon: Icon(Icons.done,),
                onPressed: (){
                  if (category == AppLocalizations.of(context).translate('Choose category') ||
                      sum == null) return; // to not add empty sum note
                  widget.expenseService.addExpenseNote(
                      Note(
                          date: date,
                          category: category,
                          sum: sum,
                          comment: comment
                      )
                  );
                  widget.navigatorService.navigateBack(context: context);
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
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: RowWithWidgets(
                      leftWidget: MainLocalText(text: 'Date'),
                      rightWidget: DateFormatText(dateTime: date, mode: 'date in string'),
                      onTap: onDateTap
                  ),
                ),
                Container(
                  decoration: AppDecoration.boxDecoration(context),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: RowWithButton(
                          leftText: 'Category',
                          rightText: category,
                          onTap: () async {
                            await widget.navigatorService.navigateToEditExpensesCategoryPage(
                              context: context,
                              category: category
                            );
                            loadAllData();
                          },
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
                        decoration: AppDecoration.boxDecoration(context),
                        width: MediaQuery.of(context).size.width - 100,
                        child:  TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),// for mobile
                          ],
                          style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color,),
                          onTap: () => sumFocusNode.requestFocus(),
                          focusNode: sumFocusNode,
                          keyboardType: TextInputType.number,
                          controller: calcController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: AppLocalizations.of(context).translate('Enter sum'),
                              hintStyle: TextStyle(color: AppColors.HINT_COLOR),
                              border: sumFocusNode.hasFocus ?
                              OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(color: Colors.blue)
                              ) :
                              InputBorder.none
                          ),
                          onChanged: (v) => sum = double.parse(v),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: AppDecoration.boxDecoration(context),
                        child: IconButton(
                            icon: Icon(
                                Icons.calculate_outlined,
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
                      style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color,),
                      focusNode: commentFocusNode,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('Enter comment'),
                        hintStyle: TextStyle(color: AppColors.HINT_COLOR),
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

