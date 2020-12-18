import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';
import '../setting/MainText.dart';

class ListOfExpensesCategories extends StatefulWidget{
  final Function callback;
  final String cat;
  ListOfExpensesCategories({this.callback, this.cat});

  @override
  _ListOfExpensesCategoriesState createState() => _ListOfExpensesCategoriesState();
}

class _ListOfExpensesCategoriesState extends State<ListOfExpensesCategories> {
  List<String> list = [];
  String tempField = '';

  initList() async{
    list = await Storage.getList('Expenses');
    if(list == null) list = [];
    list.sort();
    updateList();
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  void updateList(){
    setState(() {
      list.sort();
    });
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
      title: MainText('Категории расхода'),
    );
  }

  Widget buildBody() {
    return Column(
        children: [
          Expanded(
            child: list.isEmpty ?
            MainText('Добавьте категорию') :
            ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            child: MainText(list[index], TextAlign.left),
                            onTap: (){
                              widget.callback(list[index]);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete
                          ),
                          color: MyColors.textColor,
                          onPressed: () async{
                            list.removeAt(index);
                            await Storage.saveList(list, 'Expenses');
                            updateList();
                          }
                        )
                      ]
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          // create a new Expense category
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
                        await Storage.saveList(list, "Expenses");
                        updateList();
                      },
                    )
                  ]
                ),
                Divider()
              ]
            ),
          )
        //   IconButton(
        //     icon: Icon(Icons.ac_unit),
        //     onPressed: () async{
        //       await Storage.saveList(list, 'Expenses');
        //       list = await Storage.getList('Expenses');
        //       print(list[0]);
        //     },
        //   )
        ],
      );
  }

}