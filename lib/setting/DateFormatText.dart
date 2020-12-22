import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Utility/appLocalizations.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';
import 'package:flutter_tutorial/setting/SecondaryText.dart';
import 'package:intl/intl.dart';

class DateFormatText extends StatelessWidget {
  final DateTime dateTime;
  final String mode;
  final DateTime lastWeekDay = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday)).add(Duration(days: 7));


  DateFormatText({this.dateTime, this.mode});

  @override
  Widget build(BuildContext context) {
    switch(mode){
      case 'День':
        return MainRowText(
          AppLocalizations.of(context).translate(DateFormat.E().format(dateTime)) +
              ', ' + DateFormat.d().format(dateTime) +
              ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
              ' ' + DateFormat.y().format(dateTime)
        );

      case 'Неделя':
        return MainRowText(
          DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
              + DateFormat.d().format(lastWeekDay) + ' '
              + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
              + DateFormat.y().format(dateTime)
        );

      case 'Месяц':
        return MainRowText(AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime))+ ' '
            + DateFormat.y().format(dateTime)
        );

      case 'Год':
        return MainRowText(dateTime.year.toString());

      case 'Дата в строке' :
        return SecondaryText(
            DateFormat.d().format(dateTime) +
                ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
                ' ' + DateFormat.y().format(dateTime)
        );
    }
  }
}
