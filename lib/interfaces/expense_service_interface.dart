import 'package:flutter/material.dart';
import 'package:money_pack/interfaces/expense_categories_interface.dart';
import 'package:money_pack/interfaces/expenses_interface.dart';

import '../Objects/record.dart';

abstract class ExpenseServiceInterface implements ExpensesInterface, ExpenseCategoriesInterface {
  Future<List<Note>> getFilteredList (
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day});

  Future<double> getTotalAmountFromFilteredList(
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day});

  Future<double> getTotalAmount();
}