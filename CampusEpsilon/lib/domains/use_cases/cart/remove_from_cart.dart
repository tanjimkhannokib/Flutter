import 'package:campusepsilon/domains/entities/cart.dart';
import 'package:campusepsilon/domains/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<Cart> execute(String token, String productId) {
    return repository.removeFromCart(token, productId);
  }
}
