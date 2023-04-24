import 'package:flutter/material.dart';

class AppShadow {
  static List<BoxShadow> shadow(BuildContext context)=>
      (MediaQuery.of(context).platformBrightness == Brightness.light) ?
      [
        BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10
        ),
        BoxShadow(
            color: Colors.brown[100],
            offset: Offset(5, 5),
            blurRadius: 10
        )
      ] : [
        BoxShadow(
          color: Color.fromARGB(255, 82, 87, 93),
          offset: Offset(-5, -5),
          blurRadius: 10,

        ),
        BoxShadow(
            color: Color.fromARGB(255, 18, 23, 29),
            offset: Offset(5, 5),
            blurRadius: 10
        )
      ];
}
