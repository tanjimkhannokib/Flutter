import 'dart:io';

import 'package:campusepsilon/domains/entities/review.dart';

abstract class ReviewRepository {
  Future<Review> addReview(
    String token,
    String orderItemDetailId, {
    required int rating,
    List<File>? images,
    String? review,
    bool? anonymous,
  });

  Future<Review> updateReview(
    String token,
    String reviewId, {
    int? rating,
    List<File>? newImages,
    List<String>? oldImages,
    String? review,
    bool? anonymous,
  });

  Future<List<Review>> getProductReviews(String productId);

  Future<List<Review>> getSellerReviews(String sellerId);

  Future<List<Review>> getBuyerReviews(String token);

  Future<Review> getReview(String reviewId);
}
