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
          color: MyColors.rowColor,
          borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 5
              )
            ]
        ),
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MyColors.mainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 50,
                width: 160,
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: MainLocalText(text: leftText)),
                        Icon(Icons.arrow_drop_down, color: MyColors.textColor)
                      ],
                    ),
                    onPressed: (){
                      onTap();
                    }
                ),
              ),
              Expanded(child: SecondaryText(text: rightText.toString(), align: TextAlign.right))
            ],
          ),
        ),
      );
  }

}