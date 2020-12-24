import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../setting/MyColors.dart';


class RowWithWidgets extends StatelessWidget{
  final Function onTap;
  final Widget leftWidget;
  final Widget rightWidget;
  RowWithWidgets({this.leftWidget, this.rightWidget, this.onTap});

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
                      leftWidget,
                      Icon(Icons.arrow_drop_down, color: MyColors.textColor)
                    ],
                  ),
                  onPressed: () => onTap()
                ),
              ),
              rightWidget
            ],
          ),
        ),
      );
  }

}