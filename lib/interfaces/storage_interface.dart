import 'package:money_pack/interfaces/expense_categories_interface.dart';
import 'package:money_pack/interfaces/income_categories_interface.dart';

import 'expenses_interface.dart';
import 'incomes_interface.dart';

abstract class StorageInterface implements IncomesInterface, IncomesCategoriesInterface, ExpensesInterface, ExpenseCategoriesInterface {
  void loadFromBackup({expenseCatList, listOfExpenses, incomeCatList, listOfIncomes});
}