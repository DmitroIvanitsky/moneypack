import 'package:flutter/material.dart';
import 'large_local_text.dart';


class MainDropdownButton extends StatelessWidget {
  final String selectedMode;
  final Function callBack;
  final String page;

  MainDropdownButton({this.selectedMode, this.callBack, this.page});

  @override
  Widget build(BuildContext context) {

    if (page == 'main'){
      return DropdownButton(
          iconEnabledColor: Theme.of(context).textTheme.displayLarge.color,
          iconDisabledColor: Theme.of(context).textTheme.displayLarge.color,
          dropdownColor: Theme.of(context).backgroundColor,
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'Day', child: MainLocalText(text: 'Day')),
            DropdownMenuItem(value: 'Week', child: MainLocalText(text: 'Week')),
            DropdownMenuItem(value: 'Month', child: MainLocalText(text: 'Month')),
            DropdownMenuItem(value: 'Year', child: MainLocalText(text: 'Year')),
          ],
          onChanged: (String newValue) {
            callBack(newValue);
          }
      );
    }

    if (page == 'income' || page == 'expense'){
      return DropdownButton(
          iconEnabledColor: Theme.of(context).textTheme.displayLarge.color,
          iconDisabledColor: Theme.of(context).textTheme.displayLarge.color,
          dropdownColor: Theme.of(context).backgroundColor,
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'Day', child: MainLocalText(text: 'Day')),
            DropdownMenuItem(value: 'Week', child: MainLocalText(text: 'Week')),
            DropdownMenuItem(value: 'Week(D)', child: MainLocalText(text: 'Week(D)')),
            DropdownMenuItem(value: 'Month', child: MainLocalText(text: 'Month')),
            DropdownMenuItem(value: 'Year', child: MainLocalText(text: 'Year')),
          ],
          onChanged: (String newValue) {
            callBack(newValue);
          }
      );
    }

    if (page == 'balance'){
      return DropdownButton(
          iconEnabledColor: Theme.of(context).textTheme.displayLarge.color,
          iconDisabledColor: Theme.of(context).textTheme.displayLarge.color,
          dropdownColor: Theme.of(context).backgroundColor,
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'Week', child: MainLocalText(text: 'Week')),
            DropdownMenuItem(value: 'Year', child: MainLocalText(text: 'Year')),
          ],
          onChanged: (String newValue) {
            callBack(newValue);
          }
      );
    }
  }
}
