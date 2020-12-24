import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utility/Storage.dart';
import '../setting/MainLocalText.dart';
import '../setting/MyColors.dart';
import '../setting/MainRowText.dart';

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
        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.mainColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 5
                  )
                ]
            ),
            height: 60,
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context)
                  ),
                  MainLocalText(text: 'Категории дохода'),
                ],
              ),
            ),
          ),
        ),
        //appBar: buildAppBar(),
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
      title: MainRowText(text: 'Категории дохода'),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: list.isEmpty ?
          Center(child: MainLocalText(text: 'Добавьте категорию')) :
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
                          child: MainRowText(text: list[index]),
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