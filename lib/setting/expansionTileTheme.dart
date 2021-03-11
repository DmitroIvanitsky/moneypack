import 'package:flutter/material.dart';
import '../setting/AppColors.dart';

class ExpansionTileTheme extends StatelessWidget {
  final Widget child;

  ExpansionTileTheme({this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: AppColors.textColor(),
            unselectedWidgetColor: AppColors.textColor()
        ),
        child: this.child
    );
  }

}