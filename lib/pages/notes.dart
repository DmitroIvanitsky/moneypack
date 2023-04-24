// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:money_pack/services/notes_service.dart';
// import '../decorations/AppDecoration.dart';
// import '../Utility/appLocalizations.dart';
// import '../widgets/large_text.dart';
// import '../widgets/medium_text.dart';
// import '../widgets/customSnackBar.dart';
// import '../constants/AppColors.dart';
//
// class NotesPage extends StatefulWidget {
//
//   @override
//   _NotesPageState createState() => _NotesPageState();
// }
//
// class _NotesPageState extends State<NotesPage> {
//   List<String> list = [];
//   String tempCategory = '';
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//   FocusNode addCatFocusNode;
//   final NotesService notesService = NotesService();
//
//   @override
//   void initState() {
//     updateList();
//     addCatFocusNode = FocusNode();
//     super.initState();
//   }
//
//   void dispose() {
//     addCatFocusNode.dispose();
//     super.dispose();
//   }
//
//   void updateList() async {
//     list = await notesService.readNotes();
//     setState(() {
//       list.sort();
//     });
//   }
//
//   void undoDelete(String category, int index) async {
//     await notesService.addNote(category, index: index);
//     updateList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           title: MainLocalText(text: "Заметки"),
//         ),
//         body: Column(
//           children: [
//             SizedBox(height: 10),
//             Expanded(
//               child: list.isEmpty
//                 ? Center(child: MainLocalText(text: 'заметок нет'))
//                 : ListView.builder(
//                     itemCount: list.length,
//                     itemBuilder: (context, index) {
//                       String category = list[index];
//                       return Dismissible(
//                         key: ValueKey(category),
//                         child: Padding(
//                         padding: EdgeInsets.only(left: 5, right: 5),
//                           child: Column(
//                             children: [
//                               SizedBox(height: 25),
//                               Container(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [Expanded(child: SecondaryText(text: category))]
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         direction: DismissDirection.endToStart,
//                         onDismissed: (direction) async {
//                           CustomSnackBar.show(
//                               key: scaffoldKey,
//                               context: context,
//                               text: AppLocalizations.of(context).translate('Удалена заметка: ') + category,
//                               textColor: Colors.white,
//                               callBack: () {
//                                 undoDelete(category, index);
//                               });
//
//                           await notesService.deleteNote(category);
//                           updateList();
//                         },
//                         background: Container(),
//                         secondaryBackground: Container(
//                           alignment: Alignment.centerRight,
//                           color: Colors.redAccent,
//                           child: Padding(
//                             padding: EdgeInsets.only(right: 15),
//                             child: Icon(Icons.clear, color: Colors.black54),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: AppDecoration.boxDecoration(context),
//                       child: TextFormField(
//                         style: TextStyle(color: Theme.of(context).textTheme.displayLarge.color,),
//                         controller: TextEditingController(),
//                         decoration: InputDecoration(
//                           hintText: AppLocalizations.of(context).translate('Добавьте заметку'),
//                           hintStyle: TextStyle(color: AppColors.hint),
//                           contentPadding: EdgeInsets.all(20.0),
//                           border: addCatFocusNode.hasFocus
//                             ? OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(15)),
//                               borderSide: BorderSide(color: Colors.blue)
//                               )
//                             : InputBorder.none,
//                         ),
//                         onChanged: (v) => tempCategory = v,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 25),
//                     child: Container(
//                       height: 60,
//                       width: 60,
//                       decoration: AppDecoration.boxDecoration(context),
//                       child: IconButton(
//                         icon: Icon(Icons.add,
//                             //color: AppColors.textColor()
//                         ),
//                         onPressed: () async {
//                           if (tempCategory == '') return;
//                           //list.add(tempCategory);
//                           tempCategory = '';
//                           TextEditingController().clear();
//                           await notesService.addNote(tempCategory);
//                           //await Storage.saveNotesList(list);
//                           updateList();
//                         },
//                       ),
//                     ),
//                   )
//                 ]
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
