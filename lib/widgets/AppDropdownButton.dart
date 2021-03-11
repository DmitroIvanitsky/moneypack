import 'package:flutter/material.dart';
import '../setting/AppColors.dart';
import '../setting/MainLocalText.dart';

class AppDropdownButton extends StatelessWidget {
  final String selectedMode;
  final Function updateSelMode;
  final String page;

  AppDropdownButton({this.selectedMode, this.updateSelMode, this.page});

  @override
  Widget build(BuildContext context) {

    if (page == 'main'){
      return DropdownButton(
          iconEnabledColor: AppColors.textColor(),
          iconDisabledColor: AppColors.textColor(),
          dropdownColor: AppColors.backGroundColor(),
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
            DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
            DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
            DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
          ],
          onChanged: (String newValue) {
            updateSelMode(newValue);
          }
      );
    }

    if (page == 'income' || page == 'expense'){
      return DropdownButton(
          iconEnabledColor: AppColors.textColor(),
          iconDisabledColor: AppColors.textColor(),
          dropdownColor: AppColors.backGroundColor(),
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'День', child: MainLocalText(text: 'День')),
            DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
            DropdownMenuItem(value: 'Неделя(Д)', child: MainLocalText(text: 'Неделя(Д)')),
            DropdownMenuItem(value: 'Месяц', child: MainLocalText(text: 'Месяц')),
            DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
          ],
          onChanged: (String newValue) {
            updateSelMode(newValue);
          }
      );
    }

    if (page == 'balance'){
      return DropdownButton(
          iconEnabledColor: AppColors.textColor(),
          iconDisabledColor: AppColors.textColor(),
          dropdownColor: AppColors.backGroundColor(),
          hint: MainLocalText(text: selectedMode),
          items: [
            DropdownMenuItem(value: 'Неделя', child: MainLocalText(text: 'Неделя')),
            DropdownMenuItem(value: 'Год', child: MainLocalText(text: 'Год')),
          ],
          onChanged: (String newValue) {
            updateSelMode(newValue);
          }
      );
    }
  }
}
