import 'package:campusepsilon/domains/entities/cart.dart';
import 'package:campusepsilon/domains/repositories/cart_repository.dart';

class UpdateCart {
  final CartRepository repository;

  UpdateCart(this.repository);

  Future<Cart> execute(String token, String productId, int quantity) {
    return repository.updateCart(token, productId, quantity);
  }
}
