import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../setting/AppDecoration.dart';

import '../setting/MainLocalText.dart';
import '../setting/AppColors.dart';
import '../setting/SecondaryText.dart';

class RowWithButton extends StatelessWidget{
  final Function onTap;
  final String leftText;
  final String rightText;

  RowWithButton({this.leftText, this.rightText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: AppDecoration.boxDecoration(context),
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: AppDecoration.boxDecoration(context),
                height: 50,
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: MainLocalText(
                              text: leftText,
                              //color: Storage.brightness == Brightness.light ? AppColors.textColor() : AppColors.mainColor,
                            )
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textColor())
                      ],
                    ),
                    onPressed: () => onTap(),
                  ),
                ),
              ),
              Expanded(child: SecondaryText(text: rightText.toString(), align: TextAlign.right,))
            ],
          ),
        ),
      );
  }

}

