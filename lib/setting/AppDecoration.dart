import 'package:flutter/material.dart';
import 'package:money_pack/Utility/Storage.dart';
import 'package:money_pack/setting/AppColors.dart';
import '../setting/AppShadow.dart';

class AppDecoration {

  static BoxDecoration boxDecoration(BuildContext context){
    return BoxDecoration(
        color: AppColors.backGroundColor(),
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context)
    );
  }

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

  static BoxDecoration buttonDecoration(BuildContext context){
    Color _boxColor;

    if(Storage.brightness == Brightness.light)
      _boxColor = AppColors.mainColor;
    else
      _boxColor = AppColors.backGroundColor();

    return BoxDecoration(
        //color: _boxColor,
        color: AppColors.backGroundColor(),
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppShadow.shadow(context),
    );
  }
}