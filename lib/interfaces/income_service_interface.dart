import 'package:flutter/material.dart';
import 'package:money_pack/interfaces/income_categories_interface.dart';
import 'package:money_pack/interfaces/incomes_interface.dart';

import '../Objects/record.dart';

abstract class IncomeServiceInterface implements IncomesInterface, IncomesCategoriesInterface{
  Future<List<Note>> getFilteredList (
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day});

  Future<double> getTotalAmountFromFilteredList(
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day});

  Future<double> getTotalAmount();
}