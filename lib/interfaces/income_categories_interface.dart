abstract class IncomesCategoriesInterface {
  Future<List<String>> readIncomeCategories();

  addIncomeCategory(String category, {int index});

  editIncomeCategory(String oldCategory, String newCategory);

  deleteIncomeCategory(String category);
}