import 'package:flutter/material.dart';
import '../decorations/calendar_theme.dart';
import 'date_format_text.dart';

class DateWidget extends StatefulWidget {
  final String selMode;
  final DateTime date;
  final Function update;

  DateWidget({this.selMode, this.date, this.update});

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  @override
  Widget build(BuildContext context) {
    return getDate(selMode: widget.selMode, date: widget.date, update: widget.update, color: Theme.of(context).textTheme.displayMedium.color);
  }

  onDateTap() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return CalendarTheme.theme(child, context);
      },
    );
    if (picked != null)
      widget.update(picked);
  }

  getDate({String selMode, DateTime date, Function update, Color color}){
    switch(selMode) {
      case 'Day':
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
      case 'Week':
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
      case 'Week(D)':
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
      case 'Month':
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
      case 'Year':
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
