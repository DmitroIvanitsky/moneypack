import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../setting/SecondaryText.dart';
import '../Utility/appLocalizations.dart';
import '../widgets/customSnackBar.dart';
import '../setting/MainLocalText.dart';
import '../Utility/Storage.dart';
import '../setting/MyColors.dart';

class ListOfExpensesCategories extends StatefulWidget {
  final Function callback;
  final String cat;
  ListOfExpensesCategories({this.callback, this.cat});

  @override
  _ListOfExpensesCategoriesState createState() => _ListOfExpensesCategoriesState();
}

class _ListOfExpensesCategoriesState extends State<ListOfExpensesCategories> {
  List<String> list = [];
  String tempField = '';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    initList();
    super.initState();
  }

  initList() async {
    list = await Storage.getList('Expenses');
    if (list == null) {
      list = [AppLocalizations.of(context).translate('Продукты')];
      await Storage.saveList(list, 'Expenses');
    }
    list.sort();
    updateList();
  }

  void updateList() {
    setState(() {
      list.sort();
    });
  }

  void undoDelete(String category, int index) async {
    if (index < list.length)
      list.insert(index, category);
    else
      list.add(category);

    await Storage.saveList(list, "Expenses");
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: MyColors.backGroundColor,
        //bottomNavigationBar: buildBottomAppBar(),
        appBar: AppBar(
          shadowColor: Colors.black,
          backgroundColor: MyColors.mainColor,
          iconTheme: IconThemeData(color: MyColors.textColor),
          title: MainLocalText(text: 'Категории расходов'),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: list.isEmpty ?
              Center(child: MainLocalText(text: 'Добавьте категорию')) :
              ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  String category = list[index];
                  return Dismissible(
                    key: ValueKey(category),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 5),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.callback(category);
                                Navigator.pop(context);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [SecondaryText(text: category)]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      CustomSnackBar.show(
                          key: scaffoldKey,
                          context: context,
                          text: AppLocalizations.of(context)
                              .translate('Удалена категория: ') +
                              category,
                          textColor: Colors.white,
                          callBack: () {
                            undoDelete(category, index);
                          });
                      list.remove(category);
                      await Storage.saveList(list, 'Expenses');
                      updateList();
                    },
                    background: Container(),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.delete, color: Colors.black54,),
                      ),
                    ),
                  );
                },
              ),
            ),
            // create a new Expense category
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('Добавьте новую категорию'),
                        contentPadding: EdgeInsets.all(20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      onChanged: (v) => tempField = v,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      if (tempField == '') return;
                      list.add(tempField);
                      tempField = '';
                      TextEditingController().clear();
                      await Storage.saveList(list, "Expenses");
                      updateList();
                    },
                  )
                ]),
                Divider()
              ]),
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
        ),
      ),
    );
  }

}
