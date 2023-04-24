import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gx_file_picker/gx_file_picker.dart';

import '../interfaces/expense_service_interface.dart';
import '../interfaces/income_service_interface.dart';
import '../services/navigator_service.dart';
import '../interfaces/backup_service_interface.dart';
import '../decorations/app_decorations.dart';
import '../constants/app_colors.dart';
import '../widgets/large_local_text.dart';
import '../widgets/medium_text.dart';
import '../widgets/date_widget.dart';
import '../widgets/app_dropdown_button.dart';
import '../widgets/row_with_button.dart';

class MainPage extends StatefulWidget {
  MainPage({this.incomeService, this.expenseService, this.navigatorService, this.backupService});

  final ExpenseServiceInterface expenseService;
  final IncomeServiceInterface incomeService;
  final NavigatorService navigatorService;
  final BackupServiceInterface backupService;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  DateTime date = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selectedMode = 'Day';
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;
  double totalBalance = 0;

  @override
  void didChangeDependencies(){
    loadAllData();
    super.didChangeDependencies();
  }

  void setDate(DateTime dateTime) {
    date = dateTime;
    loadAllData();
  }

  void changeSelectedMode(String selMode){
    selectedMode = selMode;
    loadAllData();
  }

  void loadAllData() async {
    if (!mounted) return;

    totalIncome = await widget.incomeService.getTotalAmountFromFilteredList(context: context, selMode: selectedMode, currentDate: date);
    totalExpense = await widget.expenseService.getTotalAmountFromFilteredList(context: context, selMode: selectedMode, currentDate: date);
    balance = totalIncome - totalExpense;
    totalBalance = await widget.incomeService.getTotalAmount() - await widget.expenseService.getTotalAmount();
    setState(() {});
  }

  buildDrawer(){
    return Container(
      width: 350,
      child: Drawer(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: AppDecoration.boxDecoration(context),
                child: TextButton(
                  child: MainLocalText(text: 'save backup'),
                  onPressed: () => widget.backupService.saveBackup(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: AppDecoration.boxDecoration(context),
                child: TextButton(
                    child: MainLocalText(text: 'load backup'),
                    onPressed: () async {
                      File file =  await FilePicker.getFile(
                          type: FileType.custom,
                          allowedExtensions: ['json']
                      );
                      if (file != null) {
                        await widget.backupService.loadBackup(file);
                        await widget.navigatorService.navigateBack(context: context);
                        loadAllData();
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            endDrawerEnableOpenDragGesture: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: buildDrawer(),
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainLocalText(text: 'Accounting'),
                  MainDropdownButton(
                    page: 'main',
                    selectedMode: selectedMode,
                    callBack: changeSelectedMode,
                  )
                ],
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: AppDecoration.boxDecoration(context),
                      child: DateWidget(selMode: selectedMode, date: date, update: setDate),
                    ),
                  ),
                  RowWithButton(
                    leftText: 'Income',
                    rightText: totalIncome.toStringAsFixed(2),
                    onTap: () async {
                      await widget.navigatorService.navigateToIncomesListPage(
                            context: context,
                        );
                      loadAllData();
                    }
                  ),
                  RowWithButton(
                    leftText: 'Expense',
                    rightText: totalExpense.toStringAsFixed(2),
                    onTap: () async {
                      await widget.navigatorService.navigateToExpensesListPage(
                          context: context,
                        );
                      loadAllData();
                    }
                  ),
                  RowWithButton(
                    leftText: 'Balance',
                    rightText: balance.toStringAsFixed(2),
                    onTap: () async {
                      await widget.navigatorService.navigateToBalancePage(
                          context: context,
                        );
                      loadAllData();
                    }
                  ),
                  Container(
                      decoration: AppDecoration.boxDecoration(context),
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MainLocalText(text: 'Total balance'),
                                SecondaryText(text: totalBalance.toStringAsFixed(2),),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  // low buttons to add notes
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: AppDecoration.incomeButtonDecoration(context),
                            height: 70,
                            width: 215,
                            child: TextButton(
                              child: MainLocalText(
                                  text: 'Add Income',
                                  color: MediaQuery.of(context).platformBrightness == Brightness.light ?
                                  AppColors.LIGHT_TEXT_COLOR : AppColors.INCOME_BUTTON_COLOR
                              ),
                              onPressed: () async {
                                await widget.navigatorService.navigateToAddIncomePage(
                                context: context,
                                callBack: (){},
                              );
                              loadAllData();
                              }
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            decoration: AppDecoration.expenseButtonDecoration(context),
                            height: 70,
                            width: 215,
                            child: TextButton(
                              child: MainLocalText(
                                  text: 'Add Expense',
                                  color: MediaQuery.of(context).platformBrightness == Brightness.light ?
                                  AppColors.LIGHT_TEXT_COLOR : AppColors.EXPENSE_BUTTON_COLOR
                              ),
                              onPressed: () async {
                                await widget.navigatorService.navigateToAddExpensesPage(
                                    context: context,
                                  );
                                loadAllData();
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

}
