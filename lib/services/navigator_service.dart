import 'package:flutter/material.dart';
import 'package:money_pack/Objects/record.dart';
import 'package:money_pack/pages/edit_expense_category_page.dart';
import 'package:money_pack/services/expense_service.dart';
import 'package:money_pack/services/income_service.dart';

import '../interfaces/expense_service_interface.dart';
import '../interfaces/income_service_interface.dart';
import '../pages/add_expense_page.dart';
import '../pages/add_income_page.dart';
import '../pages/balance_page.dart';
import '../pages/calculator_page.dart';
import '../pages/edit_expense_page.dart';
import '../pages/edit_income_category_page.dart';
import '../pages/edit_income_page.dart';
import '../pages/expenses_list_page.dart';
import '../pages/incomes_list_page.dart';

class NavigatorService {
  static IncomeServiceInterface _incomeService;
  static ExpenseServiceInterface _expenseService;
  static bool _isInitialized = false;

  static final NavigatorService _instance = NavigatorService._();

  NavigatorService._();


  factory NavigatorService() {
    if (!_isInitialized) {
      throw Exception('NavigatorService not initialized. Need to call first initialize<IncomeService, ExpenseService>');
    } else {
      return _instance;
    }
  }

  static Future<NavigatorService> initialize({IncomeService incomeService, ExpenseService expenseService}) async {
    _incomeService = incomeService;
    _expenseService = expenseService;
    _isInitialized = true;

    return NavigatorService();
  }


  Future<double> navigateCalculator({
    BuildContext context,
    double amount
  }) async {
    return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return CalculatorPage(
              initialAmount: amount,
              navigatorService: _instance,
            );
          }
        )
    );
  }

  Future<void> navigateToEditExpensesCategoryPage({
    BuildContext context,
    String category
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              EditExpensesCategoryPage(
                category: category,
                navigatorService: _instance,
                expenseService: _expenseService,
              )
      ),
    );
  }

  Future<void> navigateToEditIncomeCategoryPage({
      BuildContext context,
      String category
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            EditIncomeCategoryPage(
              cat: category,
              navigatorService: _instance,
              incomeService: _incomeService,
            )
        ),
      );
    }

  Future<void> navigateToEditExpensePage({
      BuildContext context,
      Note note
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            EditExpensePage(
              note: note,
              navigatorService: _instance,
              expenseService: _expenseService,
            )
        )
      );
    }

  Future<void> navigateToEditIncomeNotePage({
      BuildContext context,
      Note note
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
        builder: (context) =>
          EditIncomeNotePage(
            note: note,
            navigatorService: _instance,
            incomeService: _incomeService,
          )
        )
      );
    }

  Future<void> navigateToIncomesListPage({
      BuildContext context,
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            IncomesListPage(
              navigatorService: _instance,
              incomeService: _incomeService,
            )
        )
      );
    }

  Future<void> navigateToExpensesListPage({
      BuildContext context,
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            ExpensesListPage(
              navigatorService: _instance,
              expenseService: _expenseService,
            )
        )
      );
    }

  Future<void> navigateToBalancePage({
      BuildContext context,
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            BalancePage(
              navigatorService: _instance,
              incomeService: _incomeService,
              expenseService: _expenseService,
            )
        )
      );
    }

  Future<void>  navigateToAddExpensesPage({
      BuildContext context,
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            AddExpensesPage(
              navigatorService: _instance,
              expenseService: _expenseService,
            )
        )
      );
    }



  Future<void> navigateToAddIncomePage({
      BuildContext context,
      Function callBack
    }) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
            AddIncomePage(
              navigatorService: _instance,
              incomeService: _incomeService,
            )
        )
      );
    }

    navigateBack<T>({BuildContext context, T returnValue}){
      return Navigator.of(context).pop(returnValue);
    }
}