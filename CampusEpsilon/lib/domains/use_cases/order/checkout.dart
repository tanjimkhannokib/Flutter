import 'package:campusepsilon/domains/entities/order.dart';
import 'package:campusepsilon/domains/repositories/order_repository.dart';

class Checkout {
  final OrderRepository repository;

  Checkout(this.repository);

  Future<Order> execute(String token, String addressId) {
    return repository.checkout(token, addressId);
  }
}
