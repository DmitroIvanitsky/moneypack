import 'package:flutter/material.dart';
import '../setting/DateFormatText.dart';

class GetDataWidget extends StatelessWidget {
  final String selectedMode;
  DateTime dateTime;
  final Function updatePage;

  GetDataWidget({this.selectedMode, this.dateTime, this.updatePage});

  @override
  Widget build(BuildContext context) {
    switch(selectedMode){
      case 'День':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                dateTime = dateTime.subtract(Duration(days: 1));
                updatePage();
              },
            ),
            DateFormatText(dateTime: dateTime, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                  dateTime = dateTime.add(Duration(days: 1));
                  updatePage();
              },
            ),
          ],
        );
      case 'Неделя':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                  dateTime = dateTime.subtract(Duration(days: 7));
                  updatePage();
              },
            ),
            DateFormatText(dateTime: dateTime, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                  dateTime = dateTime.add(Duration(days: 7));
                  updatePage();
              },
            ),
          ],
        );
      case 'Месяц':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                dateTime = new DateTime(dateTime.year, dateTime.month - 1, dateTime.day);
                  updatePage();
              },
            ),
            DateFormatText(dateTime: dateTime, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
                  updatePage();
              },
            ),
          ],
        );
      case 'Год':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                dateTime = new DateTime(dateTime.year - 1, dateTime.month, dateTime.day);
                  updatePage();
              },
            ),
            DateFormatText(dateTime: dateTime, mode: selectedMode),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                dateTime = DateTime(dateTime.year + 1, dateTime.month, dateTime.day);
                  updatePage();
              },
            ),
          ],
        );
    }
  }
}

/// DRAFT WIDGET