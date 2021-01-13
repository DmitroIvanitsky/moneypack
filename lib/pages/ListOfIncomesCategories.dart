import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../setting/SecondaryText.dart';
import '../Utility/appLocalizations.dart';
import '../widgets/customSnackBar.dart';
import '../Utility/Storage.dart';
import '../setting/MainLocalText.dart';
import '../setting/MyColors.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // createList () async {
  //   list.add(AppLocalizations.of(context).translate('Зарплата'));
  //   await Storage.saveList(list, "Incomes");
  // }

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async{
    list = await Storage.getList('Incomes');
    if(list == null) {
      list = [AppLocalizations.of(context).translate('Зарплата')];
      await Storage.saveList(list, 'Incomes');
    }
    list.sort();
    setState(() {});
  }

  void updateList(){
    setState(() {
      list.sort();
    });
  }

  void undoDelete(String category, int index) async {
    if (index < list.length)
      list.insert(index, category);
    else
      list.add(category);

    await Storage.saveList(list, "Incomes");
    updateList();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyColors.backGroundColor,
        //bottomNavigationBar: buildBottomAppBar(),
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBottomAppBar() {
    return BottomAppBar(
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
    );
  }

  Widget buildAppBar() {
    return AppBar(
      shadowColor: Colors.black,
      backgroundColor: MyColors.mainColor,
      iconTheme: IconThemeData(
          color: MyColors.textColor
      ),
      title: MainLocalText(text: 'Категории доходов'),
    );
  }

  Widget buildBody() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: list.isEmpty ?
          Center(child: MainLocalText(text: 'Добавьте категорию')) :
          ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index){
              String category = list[index];
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            child: SecondaryText(text: category),
                            onPressed: (){
                              widget.callback(category);
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: MyColors.buttonColor,
                            onPressed: () async{
                              CustomSnackBar.show(
                                  key: scaffoldKey,
                                  context: context,
                                  text: AppLocalizations.of(context).translate('Удалена категория: ') + category,
                                  callBack: (){
                                    undoDelete(category, index);
                                  }
                              );
                              list.remove(category);
                              await Storage.saveList(list, 'Incomes');
                              setState(() {});
                            }
                          )
                        ]
                      ),
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
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('Добавьте новую категорию'),
                        contentPadding: EdgeInsets.all(20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.blue)
                        ),
                      ),
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
                      await Storage.saveList(list, "Incomes");
                      updateList();
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