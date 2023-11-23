import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/domains/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Product> execute(String token, String productId) {
    return repository.deleteProduct(token, productId);
  }
}
