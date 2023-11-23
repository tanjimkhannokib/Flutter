import 'package:campusepsilon/domains/entities/wishlist.dart';
import 'package:campusepsilon/domains/repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  Future<Wishlist> execute(String token) {
    return repository.getWishlist(token);
  }
}
