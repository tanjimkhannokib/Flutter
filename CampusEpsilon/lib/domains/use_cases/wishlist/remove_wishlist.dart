import 'package:campusepsilon/domains/entities/wishlist.dart';
import 'package:campusepsilon/domains/repositories/wishlist_repository.dart';

class DeleteWishlist {
  final WishlistRepository repository;

  DeleteWishlist(this.repository);

  Future<Wishlist> execute(String token, String productId) {
    return repository.deleteWishlist(token, productId);
  }
}
