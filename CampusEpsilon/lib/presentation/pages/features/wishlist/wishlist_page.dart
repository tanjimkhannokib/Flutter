import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/presentation/helper_variables/provider_state.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/cart_button_appbar.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:campusepsilon/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:campusepsilon/presentation/providers/wishlist_provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Confirmation'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (Provider.of<WishlistProvider>(context, listen: false)
          .getWishlistState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<WishlistProvider>(context, listen: false).getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: const CartButtonAppBar(title: "My Wishlist"),
        body: RefreshIndicator(
          onRefresh: () => _fetchData(context),
          child: Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              if (wishlistProvider.getWishlistState == ProviderState.loading) {
                return const SingleChildFullPageScrollView.loading();
              }
              if (wishlistProvider.getWishlistState == ProviderState.error) {
                return SingleChildFullPageScrollView(
                    child: Text(wishlistProvider.message));
              }

              final products = wishlistProvider.wishlist?.wishlistProducts;

              if (products == null || products.isEmpty) {
                return const SingleChildFullPageScrollView(
                    child: Text("You don't have a wishlist"));
              }

              return MasonryGridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                crossAxisCount: 2,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final Product product = products[index];
                  return SingleProductCard(
                    product: product,
                    isWishlist: true,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
