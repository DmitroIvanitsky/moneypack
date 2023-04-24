import 'package:flutter/material.dart';
import '../Utility/app_localizations.dart';
import 'main_row_text.dart';
import 'package:intl/intl.dart';

import 'medium_text.dart';

class DateFormatText extends StatelessWidget {
  final DateTime dateTime;
  final String mode;
  final Color color;

  DateFormatText({this.dateTime, this.mode, this.color});

  @override
  Widget build(BuildContext context) {

    switch(mode){
      case 'Day':
        return MainRowText(text:
          AppLocalizations.of(context).translate(DateFormat.E().format(dateTime)) +
              ', ' + DateFormat.d().format(dateTime) +
              ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
              ' ' + DateFormat.y().format(dateTime),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );

      case 'Week':
        int weekDay = (Localizations.localeOf(context).languageCode == 'ru' ||
            Localizations.localeOf(context).languageCode == 'uk') ? dateTime.weekday : dateTime.weekday + 1;
        DateTime lastWeekDay = dateTime.subtract(
            Duration(days: weekDay)).add(Duration(days: 7));
        return MainRowText(text:
          DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
              + DateFormat.d().format(lastWeekDay) + ' '
              + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
              + DateFormat.y().format(dateTime),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );

      case 'Week(D)':
        int weekDay = (Localizations.localeOf(context).languageCode == 'ru' ||
            Localizations.localeOf(context).languageCode == 'uk') ? dateTime.weekday : dateTime.weekday + 1;
        DateTime lastWeekDay = dateTime.subtract(
            Duration(days: weekDay)).add(Duration(days: 7));
        return MainRowText(text:
        DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
            + DateFormat.d().format(lastWeekDay) + ' '
            + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
            + DateFormat.y().format(dateTime),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );
      case 'Month':
        return MainRowText(text: AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime))+ ' '
            + DateFormat.y().format(dateTime),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );

      case 'Year':
        return MainRowText(
          text: dateTime.year.toString(),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );

      case 'date in string' :
        return SecondaryText(text:
            DateFormat.d().format(dateTime) +
                ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
                ' ' + DateFormat.y().format(dateTime),
          color: color ?? Theme.of(context).textTheme.displayLarge.color,
        );
    }
  }
}
