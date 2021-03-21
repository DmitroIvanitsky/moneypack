import 'package:flutter/material.dart';
import '../setting/calendarTheme.dart';
import '../setting/DateFormatText.dart';

class DateWidget extends StatefulWidget {
  String selMode;
  DateTime date;
  Function update;
  Color color;

  DateWidget({this.selMode, this.date, this.update, this.color});

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {
    return getDate(selMode: widget.selMode, date: widget.date, update: widget.update, color: widget.color);
  }

  onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return CalendarTheme.theme(child);
      },
    );
    if (picked != null)
      widget.update(widget.date = picked);
  }

  getDate({String selMode, DateTime date, Function update, Color color}){
    switch(selMode) {
      case 'День':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: color,),
                onPressed: () {
                  date = date.subtract(Duration(days: 1));
                  widget.update(date);
                },
              ),
            ),
            TextButton(
              child: DateFormatText(dateTime: date, mode: selMode, color: color),
              onPressed: onDateTap,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = date.add(Duration(days: 1));
                  widget.update(date);
                },
              ),
            ),
          ],
        );
      case 'Неделя':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: color,),
                onPressed: () {
                  date = date.subtract(Duration(days: 7));
                  update(date);
                },
              ),
            ),
            DateFormatText(dateTime: date, mode: selMode, color: color),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = date.add(Duration(days: 7));
                  update(date);
                },
              ),
            ),
          ],
        );
      case 'Неделя(Д)':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: color,),
                onPressed: () {
                  date = date.subtract(Duration(days: 7));
                  update(date);
                },
              ),
            ),
            DateFormatText(dateTime: date, mode: selMode, color: color),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = date.add(Duration(days: 7));
                  update(date);
                },
              ),
            ),
          ],
        );
      case 'Месяц':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: color,),
                onPressed: () {
                  date = new DateTime(date.year, date.month - 1, date.day);
                  update(date);
                },
              ),
            ),
            TextButton(
              child: DateFormatText(dateTime: date, mode: selMode, color: color),
              onPressed: onDateTap,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = DateTime(date.year, date.month + 1, date.day);
                  update(date);
                },
              ),
            ),
          ],
        );
      case 'Год':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_left, color: color,),
                onPressed: () {
                  date = new DateTime(date.year - 1, date.month, date.day);
                  update(date);
                },
              ),
            ),
            DateFormatText(dateTime: date, mode: selMode, color: color),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = DateTime(date.year + 1, date.month, date.day);
                  update(date);
                },
              ),
            ),
          ],
        );
    }
  }
}
