import 'package:campusepsilon/domains/entities/order.dart';
import 'package:campusepsilon/domains/repositories/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.cancelOrder(token, orderId);
  }
}
