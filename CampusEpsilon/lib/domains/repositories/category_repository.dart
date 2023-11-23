import 'package:campusepsilon/domains/entities/category.dart';

abstract class CategoryRepository {
  Future<Category> getCategory(String categoryId);

  Future<List<Category>> getAllCategories();
}
