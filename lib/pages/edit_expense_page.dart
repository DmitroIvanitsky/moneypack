import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_pack/interfaces/expense_service_interface.dart';

import '../Objects/record.dart';
import '../decorations/calendar_theme.dart';
import '../Utility/app_localizations.dart';
import '../services/navigator_service.dart';
import '../widgets/secondary_local_text.dart';
import '../widgets/date_format_text.dart';
import '../widgets/large_local_text.dart';
import '../widgets/row_with_button.dart';
import '../widgets/row_with_widgets.dart';
import '../constants/app_colors.dart';
import '../widgets/main_row_text.dart';
import '../decorations/app_decorations.dart';

class EditExpensePage extends StatefulWidget {
  final Note note;
  final ExpenseServiceInterface expenseService;
  final NavigatorService navigatorService;

  EditExpensePage({
    this.note,
    this.navigatorService,
    this.expenseService
  });

  @override
  _EditExpensePageState createState() =>
      _EditExpensePageState(this.note);
}

class _EditExpensePageState extends State<EditExpensePage> {
  Note editableNote;
  TextEditingController calcController;
  FocusNode sumFocusNode;
  FocusNode commentFocusNode;

  _EditExpensePageState(this.editableNote);

  @override
  void initState() {
    sumFocusNode = FocusNode();
    commentFocusNode = FocusNode();
    calcController = TextEditingController(text: editableNote.sum.toString());
    super.initState();
  }

  void updateCategory(String cat) {
    setState(() {
      editableNote.category = cat;
    });
  }

  goToCalculator(BuildContext context) async {
    double result = await widget.navigatorService.navigateCalculator(
        context: context,
        amount: editableNote.sum

    );
    setState(() {
      if (editableNote.sum != result) calcController.text = result.toString();
      editableNote.sum = result;
    });
  }


  onCategoryTap(BuildContext context) async {
    await widget.navigatorService.navigateToEditExpensesCategoryPage(
        context: context,
        category: editableNote.category
    );
  }

  Widget getDateWidget(DateTime date) {
    return TextButton(
      onPressed: onDateTap,
      child: (date != null)? MainRowText(
        text: date.toString().substring(0, 10),
        align: TextAlign.left,
      ) : MainRowText(text: 'Выберите дату'),
    );
  }

  onDateTap() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 184)),
      firstDate: DateTime.now().subtract(Duration(days: 184)),
      builder:(BuildContext context, Widget child) {
        return CalendarTheme.theme(child, context);
      },
    );
    setState(() {
      editableNote.date = picked;
    });
  }

  void dispose() {
    calcController.dispose();
    sumFocusNode.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainLocalText(text: 'Edit'),
              IconButton(
                  iconSize: 35,
                  icon: Icon(Icons.done,),
                  onPressed: () async {
                    await widget.expenseService.editExpenseNote(widget.note, editableNote);
                    widget.navigatorService.navigateBack(context: context);
                  }
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RowWithWidgets(
                      leftWidget: MainLocalText(text: 'Date'),
                      rightWidget: (editableNote.date != null)?
                      DateFormatText(
                          dateTime: editableNote.date,
                          mode: 'date in string'
                      )
                          : SecondaryLocalText(text: 'Выберите дату'),
                      onTap: onDateTap
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: RowWithButton(
                    leftText: 'Category',
                    rightText: editableNote.category,
                    onTap: () => onCategoryTap(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        decoration: AppDecoration.boxDecoration(context),
                        width:  MediaQuery.of(context).size.width - 100,
                        child: TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),// for mobile
                          ],
                          onTap: () => sumFocusNode.requestFocus(),
                          focusNode: sumFocusNode,
                          keyboardType: TextInputType.number,
                          controller: calcController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              hintText: AppLocalizations.of(context).translate('Enter sum'),
                              hintStyle: TextStyle(color: AppColors.HINT_COLOR),
                              border: sumFocusNode.hasFocus ?
                              OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.blue)
                              ) : InputBorder.none
                          ),
                          onChanged: (v) => editableNote.sum = double.parse(v),
                          style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color,),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: AppDecoration.boxDecoration(context),
                        child: IconButton(
                            icon: Icon(
                                Icons.calculate_outlined,
                                //color: AppColors.textColor(),
                                size: 40
                            ),
                            onPressed: () => goToCalculator(context)
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    decoration: AppDecoration.boxDecoration(context),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(20),// for mobile
                      ],
                      focusNode: commentFocusNode,
                      maxLines: 1,
                      initialValue: editableNote.comment,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate('Enter comment'),
                          hintStyle: TextStyle(color: AppColors.HINT_COLOR),
                          contentPadding: EdgeInsets.all(20),
                          fillColor: Colors.white,
                          border: commentFocusNode.hasFocus ?
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)
                          ) : InputBorder.none
                      ),
                      onChanged: (v) => editableNote.comment = v,
                      style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color),
                    ),
                  ),
                ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
