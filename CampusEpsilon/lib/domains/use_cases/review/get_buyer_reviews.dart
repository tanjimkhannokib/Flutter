import 'package:campusepsilon/domains/entities/review.dart';
import 'package:campusepsilon/domains/repositories/review_repository.dart';

class GetBuyerReviews {
  final ReviewRepository repository;

  GetBuyerReviews(this.repository);

  Future<List<Review>> execute(String token) {
    return repository.getBuyerReviews(token);
  }
}
