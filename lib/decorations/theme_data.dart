import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'main',
    backgroundColor: AppColors.LIGHT_BACKGROUND_COLOR,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.LIGHT_TEXT_COLOR),
      shadowColor: AppColors.LIGHT_BACKGROUND_COLOR.withOpacity(.001),
      backgroundColor: AppColors.LIGHT_BACKGROUND_COLOR,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.white,
      secondary: Colors.red,
      tertiary: Colors.red
    ),
    iconTheme: IconThemeData(
      color: AppColors.LIGHT_TEXT_COLOR
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.LIGHT_TEXT_COLOR,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.LIGHT_TEXT_COLOR,
        fontSize: 17.0,
      ),
      displaySmall:  TextStyle(
        color: AppColors.LIGHT_TEXT_COLOR,
        fontSize: 15.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'main',
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
      shadowColor: AppColors.DARK_BACKGROUND_COLOR.withOpacity(.001),
      backgroundColor: AppColors.DARK_BACKGROUND_COLOR,
    ),
    backgroundColor: AppColors.DARK_BACKGROUND_COLOR,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      onPrimary: Colors.black,
      secondary: Colors.red,
      tertiary: Colors.red
    ),
    iconTheme: IconThemeData(
        color: AppColors.DARK_TEXT_COLOR
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.DARK_TEXT_COLOR,
        fontSize: 18.0,
      ),
      displayMedium: TextStyle(
        color: AppColors.DARK_TEXT_COLOR,
        fontSize: 17.0,
      ),
      displaySmall:  TextStyle(
        color: AppColors.DARK_TEXT_COLOR,
        fontSize: 15.0,
      ),
    ),
  );
}