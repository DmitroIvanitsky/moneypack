import 'package:flutter/material.dart';
import '../Utility/Storage.dart';
import '../setting/AppColors.dart';
import '../setting/AppShadow.dart';

class AppDecoration {

  // morphism decoration for all UI objects
  static BoxDecoration boxDecoration(BuildContext context){
    return BoxDecoration(
        color: AppColors.backGroundColor(),
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }

  // exception in decoration for income button (light theme color for background)
  static BoxDecoration incomeButtonDecoration(BuildContext context){
    Color _boxColor;

    if(Storage.brightness == Brightness.light)
      _boxColor = AppColors.incomeButton;
    else
      _boxColor = AppColors.backGroundColor();

    return BoxDecoration(
        color: _boxColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }

  // exception in decoration for expense button (light theme color for background)
  static BoxDecoration expenseButtonDecoration(BuildContext context){
    Color _boxColor;

    if(Storage.brightness == Brightness.light)
      _boxColor = AppColors.expenseButton;
    else
      _boxColor = AppColors.backGroundColor();

    return BoxDecoration(
        color: _boxColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }
}