import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/domains/repositories/product_repository.dart';

class GetPopularProducts {
  final ProductRepository repository;

  GetPopularProducts(this.repository);

  Future<List<Product>> execute() {
    return repository.getPopularProducts();
  }
}
