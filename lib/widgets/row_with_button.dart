import 'package:flutter/material.dart';
import '../decorations/app_decorations.dart';
import 'large_local_text.dart';
import 'medium_text.dart';

class RowWithButton extends StatelessWidget{
  final Function onTap;
  final String leftText;
  final String rightText;

  RowWithButton({this.leftText, this.rightText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        child: Container(
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
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainLocalText(text: leftText),
                        Icon(Icons.arrow_drop_down, color: Theme.of(context).textTheme.displayLarge.color)
                      ],
                    ),
                  ),
                ),
                Expanded(child: SecondaryText(text: rightText.toString(), align: TextAlign.right,))
              ],
            ),
          ),
        ),
        onTap: onTap,
      );
  }

}