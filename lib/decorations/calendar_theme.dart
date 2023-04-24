import 'package:flutter/material.dart';

class CalendarTheme{

  static theme(Widget child, BuildContext context){
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Theme.of(context).textTheme.displayLarge.color,
          onPrimary: Theme.of(context).backgroundColor,
          surface: Theme.of(context).backgroundColor,
          onSurface: Theme.of(context).textTheme.displayLarge.color,
        ),
        dialogBackgroundColor: Theme.of(context).backgroundColor,
      ),
      child: child,
    );
  }
}