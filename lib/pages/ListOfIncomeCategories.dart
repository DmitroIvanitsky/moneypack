import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MyText.dart';

class ListOfIncomeCategories extends StatefulWidget{
  final Function callback;
  final String cat;
  ListOfIncomeCategories({this.callback, this.cat});

  @override
  _ListOfIncomeCategoriesState createState() => _ListOfIncomeCategoriesState();
}

class _ListOfIncomeCategoriesState extends State<ListOfIncomeCategories> {
  List<String> list = [];
  String tempField = '';

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    list = await Storage.getList('Income');
    if(list == null) list = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColors.backGroundColor,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: MyColors.mainColor2,
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      title: MyText('Categories'),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: list.isEmpty ? CupertinoActivityIndicator(radius: 20) :
          ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: MyText(list[index]),
                          onTap: (){
                            widget.callback(list[index]);
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: MyColors.textColor,
                          onPressed: () async{
                            list.removeAt(index);
                            await Storage.saveList(list, 'Income');
                            setState(() {});
                          }
                        )
                      ]
                    ),
                    Divider(),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(),
                      onChanged: (v) => tempField = v,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async{
                      if(tempField == '') return;
                      list.add(tempField);
                      tempField = '';
                      TextEditingController().clear();
                      await Storage.saveList(list, "Income");
                      setState(() {});
                    },
                  )
                ]
              ),
              Divider()
            ]
          ),
        )
      ]
    );
  }

}