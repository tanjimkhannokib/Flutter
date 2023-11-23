import 'package:campusepsilon/domains/entities/wishlist.dart';
import 'package:campusepsilon/domains/repositories/wishlist_repository.dart';

class AddWishlist {
  final WishlistRepository repository;

  AddWishlist(this.repository);

  Future<Wishlist> execute(String token, String productId) {
    return repository.addWishlist(token, productId);
  }
}
