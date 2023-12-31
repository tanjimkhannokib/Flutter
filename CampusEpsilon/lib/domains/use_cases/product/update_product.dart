import 'dart:io';

import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/domains/repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Product> execute(
    String token,
    String productId, {
    String? name,
    List<File>? newImages,
    List<String>? oldImages,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? categoryId,
    bool? active,
  }) {
    return repository.updateProduct(
      token,
      productId,
      name: name,
      price: price,
      newImages: newImages,
      oldImages: oldImages,
      description: description,
      categoryId: categoryId,
      stock: stock,
      sku: sku,
      active: active,
    );
  }
}
