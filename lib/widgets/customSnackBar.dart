import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utility/appLocalizations.dart';

class CustomSnackBar {
  static void show ({GlobalKey<ScaffoldState> key, String text, Function callBack, BuildContext context}) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: AppLocalizations.of(context).translate('Отменить'),
          onPressed: callBack
        ),
      )
    );
  }
}