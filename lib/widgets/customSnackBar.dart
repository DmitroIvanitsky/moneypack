import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_pack/setting/MyColors.dart';
import '../Utility/appLocalizations.dart';

class CustomSnackBar {
  static void show ({GlobalKey<ScaffoldState> key, String text, Color textColor, Function callBack, BuildContext context}) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: textColor)),
        action: SnackBarAction(
          label: AppLocalizations.of(context).translate('ОТМЕНИТЬ'),
          textColor: MyColors.mainColor,
          onPressed: callBack
        ),
      )
    );
  }
}