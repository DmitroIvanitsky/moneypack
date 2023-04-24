import '../Objects/list_of_incomes.dart';
import '../Objects/record.dart';

abstract class IncomesInterface {
  Future<ListOfIncomes> readIncomeNotes();

  addIncomeNote(Note note, {int index});

  editIncomeNote(Note oldNote, Note newNote);

  deleteIncomeNote(Note incomeNote);

  Stream get listOfIncomesStream;

  Stream get listOfIncomeCategoriesStream;
}