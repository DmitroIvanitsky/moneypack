import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../setting/MainLocalText.dart';
import '../setting/MyColors.dart';
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
        decoration: BoxDecoration(
          color: MyColors.backGroundColor,
          borderRadius: BorderRadius.circular(15),
            boxShadow: MyColors.shadow
        ),
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColors.mainColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                width: 160,
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: MainLocalText(text: leftText, color: MyColors.textColor2,)),
                          Icon(Icons.arrow_drop_down, color: MyColors.textColor2)
                        ],
                      ),
                      onPressed: () => onTap(),
                    ),
                  ),
                ),
              ),
              Expanded(child: SecondaryText(text: rightText.toString(), align: TextAlign.right, color: MyColors.textColor2,))
            ],
          ),
        ),
      );
  }

}

