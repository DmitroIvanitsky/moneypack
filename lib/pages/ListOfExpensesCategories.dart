import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../setting/AppDecoration.dart';
import '../setting/SecondaryText.dart';
import '../Utility/appLocalizations.dart';
import '../widgets/customSnackBar.dart';
import '../setting/MainLocalText.dart';
import '../Utility/Storage.dart';
import '../setting/AppColors.dart';

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
  FocusNode addCatFocusNode;

  @override
  void initState() {
    initList();
    addCatFocusNode = FocusNode();
    super.initState();
  }

  void dispose() {
    addCatFocusNode.dispose();
    super.dispose();
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
        backgroundColor: AppColors.backGroundColor(),
        appBar: AppBar(
          shadowColor: AppColors.backGroundColor().withOpacity(.001),
          backgroundColor: AppColors.backGroundColor(),
          iconTheme: IconThemeData(color: AppColors.textColor()),
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
                          text: AppLocalizations.of(context).translate('Удалена категория: ') + category,
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
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: AppDecoration.boxDecoration(context),
                      child: TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10),// for mobile
                        ],
                        style: TextStyle(color: AppColors.textColor()),
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate('Добавьте новую категорию'),
                          hintStyle: TextStyle(color: AppColors.hintColor),
                          contentPadding: EdgeInsets.all(20.0),
                          border: addCatFocusNode.hasFocus
                            ? OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.blue)
                              )
                            : InputBorder.none,
                        ),
                        onChanged: (v) => tempField = v,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: AppDecoration.boxDecoration(context),
                      child: IconButton(
                        icon: Icon(Icons.add, color: AppColors.textColor(),),
                        onPressed: () async {
                          if (tempField == '') return;
                          list.add(tempField);
                          tempField = '';
                          TextEditingController().clear();
                          await Storage.saveList(list, "Expenses");
                          updateList();
                        },
                      ),
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

}
