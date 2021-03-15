import 'package:flutter/material.dart';
import '../setting/DateFormatText.dart';

class DateWidget{

  static getDate({String selMode, DateTime date, Function update, Color color}){
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
                  update(date);
                },
              ),
            ),
            DateFormatText(dateTime: date, mode: selMode, color: color,),
            Flexible(
              fit: FlexFit.tight,
              child: IconButton(
                icon: Icon(Icons.arrow_right, color: color,),
                onPressed: () {
                  date = date.add(Duration(days: 1));
                  update(date);
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
            DateFormatText(dateTime: date, mode: selMode, color: color,),
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
            DateFormatText(dateTime: date, mode: selMode, color: color,),
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
            DateFormatText(dateTime: date, mode: selMode, color: color,),
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
            DateFormatText(dateTime: date, mode: selMode, color: color,),
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