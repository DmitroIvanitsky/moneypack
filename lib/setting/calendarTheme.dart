import 'package:flutter/material.dart';
import '../setting/AppColors.dart';

class CalendarTheme{

  static theme(Widget child){
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppColors.textColor(),
          onPrimary: AppColors.backGroundColor(),
          surface: AppColors.backGroundColor(),
          onSurface: AppColors.textColor(),
        ),
        dialogBackgroundColor: AppColors.backGroundColor(),
      ),
      child: child,
    );
  }
}