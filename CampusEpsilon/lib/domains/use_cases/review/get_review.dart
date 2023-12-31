import 'package:campusepsilon/domains/entities/review.dart';
import 'package:campusepsilon/domains/repositories/review_repository.dart';

class GetReview {
  final ReviewRepository repository;

  GetReview(this.repository);

  Future<Review> execute(String reviewId) {
    return repository.getReview(reviewId);
  }
}
