import 'package:flutter/material.dart';
import '../Utility/appLocalizations.dart';
import '../setting/MainRowText.dart';
import '../setting/SecondaryText.dart';
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
        return MainRowText(text:
          AppLocalizations.of(context).translate(DateFormat.E().format(dateTime)) +
              ', ' + DateFormat.d().format(dateTime) +
              ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
              ' ' + DateFormat.y().format(dateTime)
        );

      case 'Неделя':
        return MainRowText(text:
          DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
              + DateFormat.d().format(lastWeekDay) + ' '
              + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
              + DateFormat.y().format(dateTime)
        );

      case 'Месяц':
        return MainRowText(text: AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime))+ ' '
            + DateFormat.y().format(dateTime)
        );

      case 'Год':
        return MainRowText(text: dateTime.year.toString());

      case 'Дата в строке' :
        return SecondaryText(text:
            DateFormat.d().format(dateTime) +
                ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
                ' ' + DateFormat.y().format(dateTime)
        );
    }
  }
}
