import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/setting/MyColors.dart';
import 'package:flutter_tutorial/setting/MainRowText.dart';

class ListOfIncomesCategories extends StatefulWidget{
  final Function callback;
  final String cat;
  ListOfIncomesCategories({this.callback, this.cat});

  @override
  _ListOfIncomesCategoriesState createState() => _ListOfIncomesCategoriesState();
}

class _ListOfIncomesCategoriesState extends State<ListOfIncomesCategories> {
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
    list.sort();
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
      backgroundColor: MyColors.mainColor,
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      title: MainRowText('Категории дохода'),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: list.isEmpty ? MainRowText('Добавьте категорию') :
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
                        FlatButton(
                          height: 50,
                          child: MainRowText(list[index]),
                          onPressed: (){
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