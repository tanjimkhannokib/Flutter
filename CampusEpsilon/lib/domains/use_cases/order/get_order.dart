import 'package:campusepsilon/domains/entities/order.dart';
import 'package:campusepsilon/domains/repositories/order_repository.dart';

class GetOrder {
  final OrderRepository repository;

  GetOrder(this.repository);

  Future<Order> execute(String token, String orderId) {
    return repository.getOrder(token, orderId);
  }
}
