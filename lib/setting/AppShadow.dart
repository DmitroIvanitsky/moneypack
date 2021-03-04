import 'package:flutter/material.dart';
import '../Utility/Storage.dart';

class AppShadow {

  static List<BoxShadow> shadow(BuildContext context){

    List<BoxShadow> _shadow= [];

    if (Storage.brightness == Brightness.light)
      _shadow = [
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
      ];

    if (Storage.brightness == Brightness.dark)
      _shadow =  [
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

    return _shadow;
  }
}
