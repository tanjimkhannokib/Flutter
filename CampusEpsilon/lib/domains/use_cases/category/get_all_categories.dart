import 'package:campusepsilon/domains/entities/category.dart';
import 'package:campusepsilon/domains/repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<Category>> execute() {
    return repository.getAllCategories();
  }
}
