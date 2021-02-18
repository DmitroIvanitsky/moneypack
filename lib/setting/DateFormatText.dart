import 'package:flutter/material.dart';
import 'package:money_pack/setting/MyColors.dart';
import '../Utility/appLocalizations.dart';
import '../setting/MainRowText.dart';
import '../setting/SecondaryText.dart';
import 'package:intl/intl.dart';

class DateFormatText extends StatelessWidget {
  final DateTime dateTime;
  final String mode;
  final Color color;

  DateFormatText({this.dateTime, this.mode, this.color});

  @override
  Widget build(BuildContext context) {
    Color _color;
    if (color == null)
      _color = MyColors.textColor2;
    else
      _color = color;
    switch(mode){
      case 'День':
        return MainRowText(text:
          AppLocalizations.of(context).translate(DateFormat.E().format(dateTime)) +
              ', ' + DateFormat.d().format(dateTime) +
              ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
              ' ' + DateFormat.y().format(dateTime),
          color: _color,
        );

      case 'Неделя':
        int weekDay = (Localizations.localeOf(context).languageCode == 'ru' ||
            Localizations.localeOf(context).languageCode == 'uk') ? dateTime.weekday : dateTime.weekday + 1;
        DateTime lastWeekDay = dateTime.subtract(
            Duration(days: weekDay)).add(Duration(days: 7));
        return MainRowText(text:
          DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
              + DateFormat.d().format(lastWeekDay) + ' '
              + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
              + DateFormat.y().format(dateTime),
          color: _color,
        );

      case 'Неделя(Д)':
        int weekDay = (Localizations.localeOf(context).languageCode == 'ru' ||
            Localizations.localeOf(context).languageCode == 'uk') ? dateTime.weekday : dateTime.weekday + 1;
        DateTime lastWeekDay = dateTime.subtract(
            Duration(days: weekDay)).add(Duration(days: 7));
        return MainRowText(text:
        DateFormat.d().format(lastWeekDay.subtract(Duration(days: 6))) + ' - '
            + DateFormat.d().format(lastWeekDay) + ' '
            + AppLocalizations.of(context).translate(DateFormat.MMMM().format(lastWeekDay)) + ' '
            + DateFormat.y().format(dateTime),
          color: _color,
        );
      case 'Месяц':
        return MainRowText(text: AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime))+ ' '
            + DateFormat.y().format(dateTime),
          color: _color,
        );

      case 'Год':
        return MainRowText(text: dateTime.year.toString(), color: _color,);

      case 'Дата в строке' :
        return SecondaryText(text:
            DateFormat.d().format(dateTime) +
                ' ' + AppLocalizations.of(context).translate(DateFormat.MMMM().format(dateTime)) +
                ' ' + DateFormat.y().format(dateTime),
          color: _color,
        );
    }
  }
}
