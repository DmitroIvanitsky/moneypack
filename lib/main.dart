import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_pack/services/backup_service.dart';
import 'package:money_pack/services/navigator_service.dart';

import 'pages/main_page.dart';
import 'repository/persistent_storage.dart';
import 'services/income_service.dart';
import 'services/expense_service.dart';
import 'Utility/app_localizations.dart';
import 'decorations/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesStorage storage = await SharedPreferencesStorage.initialize();

  IncomeService incomeService = await IncomeService.initialize(
      storage: storage,
      firstSampleCategory: 'Salary'
  );

  ExpenseService expenseService = await ExpenseService.initialize(
      storage: storage,
      firstSampleCategory: 'Food'
  );

  NavigatorService navigatorService = await NavigatorService.initialize(
      incomeService: incomeService,
      expenseService: expenseService
  );

  BackupService backupService = await BackupService.initialize(
    storage: storage,
    expenseServ: expenseService,
    incomeServ: incomeService
  );

  SystemChrome.setPreferredOrientations([ //Lock orientation
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
  theme: AppTheme.lightTheme, //light theme
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  debugShowCheckedModeBanner: false,
  localizationsDelegates: [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate
  ],
  supportedLocales: [
    const Locale.fromSubtags(languageCode: 'en'),
    const Locale.fromSubtags(languageCode: 'ru'),
    const Locale.fromSubtags(languageCode: 'uk'),
  ],
  home: MainPage(
    incomeService: incomeService,
    expenseService: expenseService,
    navigatorService: navigatorService,
    backupService: backupService,
  ),
));
}
