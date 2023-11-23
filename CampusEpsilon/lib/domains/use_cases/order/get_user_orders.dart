import 'package:campusepsilon/domains/entities/order.dart';
import 'package:campusepsilon/domains/repositories/order_repository.dart';

class GetUserOrders {
  final OrderRepository repository;

  GetUserOrders(this.repository);

  Future<List<Order>> execute(String token) {
    return repository.getUserOrders(token);
  }
}
