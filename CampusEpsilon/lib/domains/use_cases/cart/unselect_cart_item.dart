import 'package:campusepsilon/domains/entities/cart.dart';
import 'package:campusepsilon/domains/repositories/cart_repository.dart';

class UnselectCartItem {
  final CartRepository repository;

  UnselectCartItem(this.repository);

  Future<Cart> execute(String token, String productId) {
    return repository.unselectCartItem(token, productId);
  }
}
