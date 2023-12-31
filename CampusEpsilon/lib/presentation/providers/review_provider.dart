import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:campusepsilon/domains/entities/review.dart';
import 'package:campusepsilon/domains/use_cases/review/add_review.dart';
import 'package:campusepsilon/domains/use_cases/review/get_buyer_reviews.dart';
import 'package:campusepsilon/domains/use_cases/review/get_product_reviews.dart';
import 'package:campusepsilon/domains/use_cases/review/get_review.dart';
import 'package:campusepsilon/domains/use_cases/review/get_seller_reviews.dart';
import 'package:campusepsilon/domains/use_cases/review/update_review.dart';
import 'package:campusepsilon/presentation/helper_variables/provider_state.dart';

class ReviewProvider with ChangeNotifier {
  final AddReview _addReview;
  final UpdateReview _updateReview;
  final GetBuyerReviews _getBuyerReviews;
  final GetSellerReviews _getSellerReviews;
  final GetProductReviews _getProductReviews;
  final GetReview _getReview;

  final String? _authToken;

  Review? _review;

  Review? get review => _review;

  List<Review>? _buyerReviews;
  List<Review>? _sellerReviews;
  List<Review>? _productReviews;

  List<Review>? get buyerReviews => [...?_buyerReviews];

  List<Review>? get sellerReviews => [...?_sellerReviews];

  List<Review>? get productReviews => [...?_productReviews];

  String _message = "";

  String get message => _message;

  ReviewProvider({
    required GetProductReviews getProductReviews,
    required GetSellerReviews getSellerReviews,
    required GetBuyerReviews getBuyerReviews,
    required AddReview addReview,
    required UpdateReview updateReview,
    required GetReview getReview,
    required String? authToken,
  })  : _getProductReviews = getProductReviews,
        _getSellerReviews = getSellerReviews,
        _getBuyerReviews = getBuyerReviews,
        _addReview = addReview,
        _updateReview = updateReview,
        _getReview = getReview,
        _authToken = authToken;

  ProviderState _getBuyerReviewsState = ProviderState.empty;

  ProviderState get getBuyerReviewsState => _getBuyerReviewsState;

  ProviderState _getSellerReviewsState = ProviderState.empty;

  ProviderState get getSellerReviewsState => _getSellerReviewsState;

  ProviderState _getProductReviewsState = ProviderState.empty;

  ProviderState get getProductReviewsState => _getProductReviewsState;

  ProviderState _getReviewState = ProviderState.empty;

  ProviderState get getReviewState => _getReviewState;

  Future<void> getBuyerReviews() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getBuyerReviewsState = ProviderState.loading;
      notifyListeners();

      final reviews = await _getBuyerReviews.execute(_authToken!);

      _buyerReviews = reviews;
      _getBuyerReviewsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getBuyerReviewsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getProductReviews(String productId) async {
    try {
      _getProductReviewsState = ProviderState.loading;
      notifyListeners();

      final reviews = await _getProductReviews.execute(productId);

      _productReviews = reviews;
      _getProductReviewsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getProductReviewsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<Review> addReview(
    String orderItemDetailId, {
    required int rating,
    List<File>? images,
    String? review,
    bool? anonymous,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final newReview = await _addReview.execute(
        _authToken!,
        orderItemDetailId,
        rating: rating,
        review: review,
        images: images,
        anonymous: anonymous,
      );

      getBuyerReviews();
      return newReview;
    } catch (e) {
      rethrow;
    }
  }

  Future<Review> updateReview(
    String reviewId, {
    int? rating,
    List<File>? newImages,
    List<String>? oldImages,
    String? review,
    bool? anonymous,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final updatedReview = await _updateReview.execute(
        _authToken!,
        reviewId,
        rating: rating,
        review: review,
        oldImages: oldImages,
        newImages: newImages,
        anonymous: anonymous,
      );

      getBuyerReviews();
      return updatedReview;
    } catch (e) {
      rethrow;
    }
  }

  Future<Review?> getReview(String id) async {
    try {
      _getReviewState = ProviderState.loading;
      notifyListeners();

      final review = await _getReview.execute(id);
      _review = review;
      _getReviewState = ProviderState.loaded;
      notifyListeners();
      return review;
    } catch (e) {
      _message = e.toString();
      _getReviewState = ProviderState.error;
      notifyListeners();
      return null;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
