import 'package:flutter/material.dart';

class MyApp2 extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  var br = Brightness.dark;
  int i = 1;
  void _changeBrightness(){
    i++;
    if(i % 2 != 0){
      setState(() {
        br = Brightness.light;
      });
    }
    else{
      setState(() {
        br = Brightness.dark;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData(
            brightness: br
        ),
        home: Scaffold(
          body: Center(
            child: Text(
              'Hello World',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 50),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _changeBrightness,
            child: Icon(Icons.refresh),
          ),
        )
    );
  }
}