import 'package:flutter/material.dart';
import '../setting/MainLocalText.dart';

class BuildDropDownButton extends StatelessWidget {
  String selectedMode;
  final Function updatePage;


  BuildDropDownButton({this.selectedMode, this.updatePage});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        hint: MainLocalText(text: selectedMode),
        items: [
          DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
          DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
          //DropdownMenuItem(value: 'Неделя(Д)', child: MainLocalText(text: 'Неделя(Д)')),
          DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
          DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
        ],
        onChanged: (String newValue) {
          selectedMode = newValue;
          updatePage();
        }
    );
  }
}

/// DRAFT WIDGET