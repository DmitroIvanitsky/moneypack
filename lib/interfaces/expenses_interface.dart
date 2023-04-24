import '../Objects/list_of_expenses.dart';
import '../Objects/record.dart';

abstract class ExpensesInterface {
  Future<ListOfExpenses> readExpenseNotes();

  addExpenseNote(Note note, {int index});

  editExpenseNote(Note oldNote, Note newNote);

  deleteExpenseNote(Note note);

  Stream get listOfExpensesStream;

  Stream get listOfExpensesCategoriesStream;
}