import 'package:campusepsilon/domains/entities/cart.dart';
import 'package:campusepsilon/domains/repositories/cart_repository.dart';

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  Future<Cart> execute(String token) {
    return repository.clearCart(token);
  }
}
