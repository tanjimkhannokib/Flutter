import 'dart:convert';

import 'package:campusepsilon/data/models/product_model.dart';
import 'package:campusepsilon/domains/entities/cart_item_detail.dart';

class CartItemDetailModel {
  final ProductModel product;
  final int quantity;
  final String id;
  final bool selected;

  CartItemDetail toEntity() {
    return CartItemDetail(
      id: id,
      product: product.toEntity(),
      quantity: quantity,
      selected: selected,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemDetailModel.fromJson(String source) =>
      CartItemDetailModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const CartItemDetailModel({
    required this.product,
    required this.quantity,
    required this.id,
    required this.selected,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemDetailModel &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          quantity == other.quantity &&
          id == other.id &&
          selected == other.selected);

  @override
  int get hashCode =>
      product.hashCode ^ quantity.hashCode ^ id.hashCode ^ selected.hashCode;

  @override
  String toString() {
    return 'CartItemDetailModel{ product: $product, quantity: $quantity, id: $id, selected: $selected,}';
  }

  CartItemDetailModel copyWith({
    ProductModel? product,
    int? quantity,
    String? id,
    bool? selected,
  }) {
    return CartItemDetailModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'quantity': quantity,
      'selected': selected,
      '_id': id,
    };
  }

  factory CartItemDetailModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      // Handle the case where the map is null, for example, by returning a default or throwing an error.
      throw Exception('Failed to decode CartItemDetailModel: Map is null.');
    }

    final product = ProductModel.fromMap(map['product']);
    if (product == null) {
      // Handle the case where the 'product' field is null or invalid.
      throw Exception('Failed to decode CartItemDetailModel: Product is null or invalid.');
    }

    final quantity = map['quantity'];
    final selected = map['selected'];
    final id = map['_id'];

    if (quantity == null || selected == null || id == null) {
      // Handle the case where any of these fields are null.
      throw Exception('Failed to decode CartItemDetailModel: Field(s) are null.');
    }

    if (quantity is! int || selected is! bool || id is! String) {
      // Handle the case where the data types are not as expected.
      throw Exception('Failed to decode CartItemDetailModel: Invalid data types.');
    }

    return CartItemDetailModel(
      product: product,
      quantity: quantity,
      selected: selected,
      id: id,
    );
  }


//</editor-fold>
}
