import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../decorations/app_shadows.dart';

class AppDecoration {

  // morphism decoration for all UI objects
  static BoxDecoration boxDecoration(BuildContext context){
    return BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }

  // exception in decoration for income button (light theme color for background)
  static BoxDecoration incomeButtonDecoration(BuildContext context){
    Color _boxColor;

    if(MediaQuery.of(context).platformBrightness == Brightness.light)
      _boxColor = AppColors.INCOME_BUTTON_COLOR;
    else
      _boxColor = Theme.of(context).backgroundColor;

    return BoxDecoration(
        color: _boxColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }

  // exception in decoration for expense button (light theme color for background)
  static BoxDecoration expenseButtonDecoration(BuildContext context){
    Color _boxColor;

    if(MediaQuery.of(context).platformBrightness == Brightness.light)
      _boxColor = AppColors.EXPENSE_BUTTON_COLOR;
    else
      _boxColor = Theme.of(context).backgroundColor;

    return BoxDecoration(
        color: _boxColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }
}