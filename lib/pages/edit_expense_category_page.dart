import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../decorations/app_decorations.dart';
import '../Utility/app_localizations.dart';
import '../services/expense_service.dart';
import '../services/navigator_service.dart';
import '../widgets/large_local_text.dart';
import '../widgets/medium_text.dart';
import '../widgets/custom_snack_bar.dart';
import '../constants/app_colors.dart';

class EditExpensesCategoryPage extends StatefulWidget {
  final String category;
  final ExpenseService expenseService;
  final NavigatorService navigatorService;

  EditExpensesCategoryPage({this.category, this.expenseService, this.navigatorService});

  @override
  _EditExpensesCategoryPageState createState() => _EditExpensesCategoryPageState();
}

class _EditExpensesCategoryPageState extends State<EditExpensesCategoryPage> {
  List<String> expenseCategories = [];
  String tempField = '';
  FocusNode addCatFocusNode;
  StreamSubscription listOfExpenseCategoriesStreamSubscription;

  @override
  void initState() {
    addCatFocusNode = FocusNode();
    listOfExpenseCategoriesStreamSubscription = widget.expenseService.listOfExpensesStream.listen((event) {
      loadAllData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies(){
    loadAllData();
    super.didChangeDependencies();
  }

  void dispose() {
    addCatFocusNode.dispose();
    listOfExpenseCategoriesStreamSubscription.cancel();
    super.dispose();
  }

  void loadAllData() async {
    expenseCategories = await widget.expenseService.readExpenseCategories();
    setState(() {
      expenseCategories.sort();
    });
  }

  void undoDelete(String category, int index) async {
    widget.expenseService.addExpenseCategory(category, index: index);
    loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MainLocalText(text: 'Expenses categories'),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: expenseCategories.isEmpty ?
              Center(child: MainLocalText(text: 'Add category')) :
              ListView.builder(
                itemCount: expenseCategories.length,
                itemBuilder: (context, index) {
                  String category = expenseCategories[index];
                  return Dismissible(
                    key: ValueKey(category),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 5),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {//set as first
                                await widget.expenseService.deleteExpenseCategory(category);
                                await widget.expenseService.addExpenseCategory(category);
                                await widget.navigatorService.navigateBack(context: context);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [SecondaryText(text: category)]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      CustomSnackBar.show(
                          context: context,
                          text: AppLocalizations.of(context).translate('Deleted category: ') + category,
                          textColor: Colors.white,
                          callBack: () {
                            undoDelete(category, index);
                          });

                      expenseCategories.remove(category);
                      await widget.expenseService.deleteExpenseCategory(category);
                      loadAllData();
                    },
                    background: Container(),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.delete, color: Colors.black54,),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: AppDecoration.boxDecoration(context),
                      child: TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10),// for mobile
                        ],
                        style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color,),
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate('Add new category'),
                          hintStyle: TextStyle(color: AppColors.HINT_COLOR),
                          contentPadding: EdgeInsets.all(20.0),
                          border: addCatFocusNode.hasFocus
                            ? OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.blue)
                              )
                            : InputBorder.none,
                        ),
                        onChanged: (v) => tempField = v,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: AppDecoration.boxDecoration(context),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          //color: AppColors.textColor(),
                        ),
                        onPressed: () async {
                          if (tempField == '') return;

                          expenseCategories.add(tempField);
                          await widget.expenseService.addExpenseCategory(tempField);
                          tempField = '';
                          TextEditingController().clear();
                          loadAllData();
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

}
