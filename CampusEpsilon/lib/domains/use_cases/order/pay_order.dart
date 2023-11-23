import 'package:campusepsilon/domains/entities/order.dart';
import 'package:campusepsilon/domains/repositories/order_repository.dart';

class PayOrder {
  final OrderRepository repository;

  PayOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.payOrder(token, orderId);
  }
}
