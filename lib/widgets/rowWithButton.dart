import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/setting/MainLocalText.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';

class RowWithButton extends StatelessWidget{
  final Function onTap;
  String leftText;
  String rightText;
  RowWithButton({this.leftText, this.rightText, this.onTap});

  Widget myFlatButton({String buttonName}){
    Color buttonColor = Colors.black;
    if (buttonName == 'Добавить расход')
      buttonColor = MyColors.expenseButton;
    if (buttonName == 'Добавить доход')
      buttonColor = MyColors.incomeButton;
    return Container(
      height: 70,
      width: 200,
      color: buttonColor,
      child: FlatButton(
          onPressed: () => onTap(buttonName),
          child: MainLocalText(buttonName)
      ),
    );
  }

  Widget viewInfoButton({String buttonName}){
    return Container(
      height: 51,
      width: 144,
      color: MyColors.mainColor,
      child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: MainLocalText(buttonName)),
              Icon(Icons.arrow_drop_down, color: MyColors.textColor)
            ],
          ),
          onPressed: () => onTap(buttonName)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        color: MyColors.rowColor,
        height: 51,
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Padding(
          padding: EdgeInsets.only(right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              viewInfoButton(buttonName: leftText),
              MainRowText(rightText.toString(), TextAlign.right),
            ],
          ),
        ),
      );
  }

}