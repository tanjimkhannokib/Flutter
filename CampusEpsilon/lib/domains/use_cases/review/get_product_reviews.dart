import 'package:campusepsilon/domains/entities/review.dart';
import 'package:campusepsilon/domains/repositories/review_repository.dart';

class GetProductReviews {
  final ReviewRepository repository;

  GetProductReviews(this.repository);

  Future<List<Review>> execute(String productId) {
    return repository.getProductReviews(productId);
  }
}
