import 'package:campusepsilon/domains/entities/order_item.dart';
import 'package:campusepsilon/domains/repositories/order_item_repository.dart';

class GetOrderItem {
  final OrderItemRepository repository;

  GetOrderItem(this.repository);

  Future<OrderItem> execute(String token, String orderItemId) {
    return repository.getOrderItem(token, orderItemId);
  }
}
