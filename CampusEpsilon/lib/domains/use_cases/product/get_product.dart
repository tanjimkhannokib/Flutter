import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/domains/repositories/product_repository.dart';

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);

  Future<Product> execute(String id) {
    return repository.getProduct(id);
  }
}
