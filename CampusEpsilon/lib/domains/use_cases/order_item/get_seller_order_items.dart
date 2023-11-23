import 'package:campusepsilon/domains/entities/order_item.dart';
import 'package:campusepsilon/domains/repositories/order_item_repository.dart';

class GetSellerOrderItems {
  final OrderItemRepository repository;

  GetSellerOrderItems(this.repository);

  Future<List<OrderItem>> execute(String token) {
    return repository.getSellerOrderItems(token);
  }
}
