import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class ListOfCategories extends StatefulWidget{
  Function callback;
  String cat;
  ListOfCategories({this.callback, this.cat});

  @override
  _ListOfCategoriesState createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  List<String> list = [];
  String tempField = '';

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    list = await Storage.getList('Expenses');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroudColor,
      appBar: AppBar(
        backgroundColor: MyColors.appBarColor,
        iconTheme: IconThemeData(
            color: MyColors.textColor
        ),
        title: MyText('Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: list.isEmpty ? CircularProgressIndicator() :
            ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    GestureDetector(
                      child: MyText(list[index]),
                      onTap: (){
                        widget.callback(list[index]);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(),
                  ],
                );
              },
        ),
          ),
          Column(
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                  onChanged: (v) => tempField = v,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async{
                    if(tempField == '') return;
                    list.add(tempField);
                    tempField = '';
                    await Storage.saveList(list, "Expenses");
                    setState(() {});
                  },
                )
              ]
            ),
              Divider()
          ]
          )
          // IconButton(
          //   icon: Icon(Icons.ac_unit),
          //   onPressed: () async{
          //     await Storage.saveList(list, 'Expenses');
          //     List l = await Storage.getList('Expenses');
          //     print(l[1]);
          //   },
          // )
      ],
      ),
    );
  }
}