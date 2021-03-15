import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../setting/AppDecoration.dart';
import '../setting/AppColors.dart';


class RowWithWidgets extends StatelessWidget{
  final Function onTap;
  final Widget leftWidget;
  final Widget rightWidget;
  RowWithWidgets({this.leftWidget, this.rightWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Container(
          decoration: AppDecoration.boxDecoration(context),
          height: 50,
          //width: 350,
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
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        leftWidget,
                        Icon(Icons.arrow_drop_down, color: AppColors.textColor())
                      ],
                    ),
                    onPressed: () => onTap()
                  ),
                ),
                rightWidget
              ],
            ),
          ),
        ),
      );
  }

}