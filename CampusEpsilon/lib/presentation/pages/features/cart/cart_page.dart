import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/presentation/helper_variables/format_tk.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:campusepsilon/presentation/pages/features/cart/checkout_page.dart';
import 'package:campusepsilon/presentation/pages/features/cart/widgets/cart_item_tile.dart';
import 'package:campusepsilon/presentation/providers/cart_provider.dart';
import 'package:campusepsilon/presentation/helper_variables/provider_state.dart';

class CartPage extends StatefulWidget {
  static const String routeName = "/cart";

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (Provider.of<CartProvider>(context, listen: false).getCartState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<CartProvider>(context, listen: false).getCart();
  }

//https://hesam-kamalan.medium.com/how-to-prevent-the-keyboard-pushes-a-widget-up-on-flutter-873569449927
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: const Text("Cart"),backgroundColor: Colors.green,),
            body: SizedBox(
              height: double.infinity,
              child: RefreshIndicator(
                onRefresh: () => _fetchData(context),
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    if (cartProvider.getCartState == ProviderState.loading) {
                      return const SingleChildFullPageScrollView.loading();
                    }
                    if (cartProvider.getCartState == ProviderState.error) {
                      return SingleChildFullPageScrollView(
                          child: Text(cartProvider.message));
                    }

                    final cartItems = cartProvider.cart?.cartItems;

                    if (cartItems == null || cartItems.isEmpty) {
                      return const SingleChildFullPageScrollView(
                          child: Text("Your cart is empty!"));
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 5),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        return CartItemTile(cartItem: cartItem);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            elevation: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: "Total Price\n",
                          style: theme.textTheme.titleSmall,
                          children: [
                            TextSpan(
                                text: rupiahFormatter
                                    .format(cartProvider.totalPrice),
                                style: theme.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold))
                          ]),
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                            textStyle: theme.textTheme.titleMedium),
                        onPressed: cartProvider.totalSelectedItemCount == 0
                            ? null
                            : () => Navigator.of(context)
                                .pushNamed(CheckoutPage.routeName),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                              "Buy (${cartProvider.totalSelectedItemCount})"),
                        )),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
