import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_pack/interfaces/income_service_interface.dart';
import '../decorations/app_decorations.dart';
import '../Utility/app_localizations.dart';
import '../services/navigator_service.dart';
import '../widgets/large_local_text.dart';
import '../widgets/medium_text.dart';
import '../widgets/custom_snack_bar.dart';
import '../constants/app_colors.dart';

class EditIncomeCategoryPage extends StatefulWidget{
  final String cat;
  final IncomeServiceInterface incomeService;
  final NavigatorService navigatorService;

  EditIncomeCategoryPage({this.cat, this.navigatorService, this.incomeService});

  @override
  _EditIncomeCategoryPageState createState() => _EditIncomeCategoryPageState();
}

class _EditIncomeCategoryPageState extends State<EditIncomeCategoryPage> {
  List<String> incomeCategoriesList = [];
  String editableCategory = '';
  FocusNode addCatFocusNode;

  @override
  void initState() {
    addCatFocusNode = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies(){
    loadAllData();
    super.didChangeDependencies();
  }

  void dispose() {
    addCatFocusNode.dispose();
    super.dispose();
  }

  void loadAllData() async {
    incomeCategoriesList = await widget.incomeService.readIncomeCategories();
    setState(() {
      incomeCategoriesList.sort();
    });
  }

  void undoDelete(String category, int index) async {
    await widget.incomeService.addIncomeCategory(category, index: index);
    await loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: MainLocalText(text: 'Incomes categories'),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: incomeCategoriesList.isEmpty ?
              Center(child: MainLocalText(text: 'Add category')) :
              ListView.builder(
                itemCount: incomeCategoriesList.length,
                itemBuilder: (context, index){
                  String category = incomeCategoriesList[index];
                  return Dismissible(
                      key: ValueKey(category),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: GestureDetector(//set as first
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await widget.incomeService.deleteIncomeCategory(category);
                                  await widget.incomeService.addIncomeCategory(category);
                                  await widget.navigatorService.navigateBack(context: context);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SecondaryText(text: category),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async{
                      CustomSnackBar.show(
                          context: context,
                          text: AppLocalizations.of(context).translate(
                              'Deleted category: ') + category,
                          textColor: Colors.white,
                          callBack: (){
                            undoDelete(category, index);
                          }
                      );

                      await widget.incomeService.deleteIncomeCategory(category);
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
                        onChanged: (v) => editableCategory = v,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: AppDecoration.boxDecoration(context),
                      child: IconButton(
                        icon: Icon(Icons.add,
                          //color: AppColors.textColor(),
                        ),
                        onPressed: () async{
                          if(editableCategory.length == 0) return;
                          await widget.incomeService.addIncomeCategory(editableCategory);
                          editableCategory = '';
                          TextEditingController().clear();
                          loadAllData();
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}