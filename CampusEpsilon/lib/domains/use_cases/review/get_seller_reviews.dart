import 'package:campusepsilon/domains/entities/review.dart';
import 'package:campusepsilon/domains/repositories/review_repository.dart';

class GetSellerReviews {
  final ReviewRepository repository;

  GetSellerReviews(this.repository);

  Future<List<Review>> execute(String sellerId) {
    return repository.getSellerReviews(sellerId);
  }
}
