import 'dart:convert';
import 'dart:io';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

import 'package:money_pack/interfaces/backup_service_interface.dart';
import '../Objects/all_data.dart';
import '../Objects/list_of_expenses.dart';
import '../Objects/list_of_incomes.dart';
import '../interfaces/expense_service_interface.dart';
import '../interfaces/income_service_interface.dart';
import '../interfaces/storage_interface.dart';


class BackupService implements BackupServiceInterface {
  static StorageInterface _storage;
  static IncomeServiceInterface _incomeService;
  static ExpenseServiceInterface _expenseService;
  static bool _isInitialized = false;

  static final BackupService _instance = BackupService._();

  BackupService._();


  factory BackupService() {
    if (!_isInitialized) {
      throw Exception(
          'BackupService not initialized. Need to call first initialize<>');
    } else {
      return _instance;
    }
  }

  static Future<BackupService> initialize(
      {StorageInterface storage, IncomeServiceInterface incomeServ, ExpenseServiceInterface expenseServ}) async {
    _storage = storage;
    _incomeService = incomeServ;
    _expenseService = expenseServ;
    _isInitialized = true;

    return BackupService();
  }

  void saveBackup() async {
    List<String> expenseCatList = await _expenseService.readExpenseCategories();
    List<String> incomeCatList = await _incomeService.readIncomeCategories();
    ListOfExpenses listOfExpenses = await _expenseService.readExpenseNotes();
    ListOfIncomes listOfIncomes = await _incomeService.readIncomeNotes();

    AllData backupObject = AllData(
      expenseCatList: expenseCatList,
      incomeCatList: incomeCatList,
      listOfExpenses: listOfExpenses,
      listOfIncomes: listOfIncomes,
    );

    String appDir = (await getApplicationDocumentsDirectory()).path;//Get app directory path
    File file = File(appDir + '/MPBackup.json');
    await file.writeAsString(jsonEncode(backupObject.toJson()));
    await Share.shareFiles([file.path]);
  }

  void loadBackup(File file) async {
    String res = await file.readAsString();
    AllData backupObject = AllData.fromJson(jsonDecode(res));
    await _storage.loadFromBackup(
        expenseCatList: backupObject.expenseCatList,
        listOfExpenses: backupObject.listOfExpenses,
        incomeCatList: backupObject.incomeCatList,
        listOfIncomes: backupObject.listOfIncomes
    );
  }
}