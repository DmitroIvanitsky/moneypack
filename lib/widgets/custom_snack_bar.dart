import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../Utility/app_localizations.dart';

class CustomSnackBar {
  static void show ({GlobalKey<ScaffoldState> key, String text, Color textColor, Function callBack, BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: textColor)),
        action: SnackBarAction(
          label: AppLocalizations.of(context).translate('UNDO'),
          textColor: AppColors.DELETE_COLOR,
          onPressed: callBack
        ),
      )
    );
  }
}