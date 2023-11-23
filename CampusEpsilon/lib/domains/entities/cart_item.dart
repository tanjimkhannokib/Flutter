import 'package:campusepsilon/domains/entities/cart_item_detail.dart';
import 'package:campusepsilon/domains/entities/user.dart';

class CartItem {
  CartItem({
    required this.seller,
    required this.id,
    required this.cartItemDetails,
  });

  final User? seller;
  final String? id;
  final List<CartItemDetail>? cartItemDetails;
}
