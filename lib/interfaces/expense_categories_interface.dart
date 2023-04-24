abstract class ExpenseCategoriesInterface {
  Future<List<String>> readExpenseCategories();

  void addExpenseCategory(String category, {int index});

  void editExpenseCategory(String oldCategory, String newCategory);

  void deleteExpenseCategory(String category);
}