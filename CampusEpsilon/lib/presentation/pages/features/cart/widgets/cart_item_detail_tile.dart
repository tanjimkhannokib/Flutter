import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/presentation/helper_variables/format_tk.dart';
import 'package:campusepsilon/domains/entities/cart_item_detail.dart';
import 'package:campusepsilon/presentation/helper_variables/future_function_handler.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/custom_form_field.dart';
import 'package:campusepsilon/presentation/pages/features/product/view_product_page.dart';
import 'package:campusepsilon/presentation/providers/cart_provider.dart';
import 'package:campusepsilon/presentation/providers/wishlist_provider.dart';

class CartItemDetailTile extends StatefulWidget {
  final CartItemDetail cartItemDetail;
  final ValueNotifier<bool> checkBoxNotifier;
  final Function updateCheckBoxState;

  const CartItemDetailTile(
      {Key? key,
      required this.cartItemDetail,
      required this.checkBoxNotifier,
      required this.updateCheckBoxState})
      : super(key: key);

  @override
  State<CartItemDetailTile> createState() => _CartItemDetailTileState();
}

class _CartItemDetailTileState extends State<CartItemDetailTile> {
  bool loading = true;
  bool selected = true;
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _quantityFocus = FocusNode();
  int quantity = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        setState(() {
          loading = false;
          selected = widget.cartItemDetail.selected!;
          quantity = widget.cartItemDetail.quantity!;
          _quantityController.text = quantity.toString();
        });
      }
    });
    _quantityFocus.addListener(_handleFocusChange);

    //to synchronize shop checkbox with product checkbox
    widget.checkBoxNotifier.addListener(() {
      if (mounted) {
        setState(() => selected = widget.checkBoxNotifier.value);
      }
    });
  }

  //update quantity when unfocused
  void _handleFocusChange() {
    if (!_quantityFocus.hasFocus) {
      updateQuantity();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
    _quantityFocus.dispose();
  }

  // click + button
  void addToCart(BuildContext context) async {
    setState(() {
      quantity++;
      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });
    updateCart(context);
  }

  // click - button
  void removeFromCart(BuildContext context) async {
    setState(() {
      quantity--;
      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });
    updateCart(context);
  }

  // edit quantity directly
  void updateQuantity() {
    setState(() {
      quantity = max(int.tryParse(_quantityController.text) ?? 1, 1);

      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });

    updateCart(context);
  }

  // run when clicking + or - button or when updating quantity manually
  void updateCart(BuildContext context) async {
    await Provider.of<CartProvider>(context, listen: false)
        .updateCart(widget.cartItemDetail.product!.id!, quantity);
  }

  void toggleCartItem(BuildContext context, bool value) async {
    setState(() => selected = value);
    widget.updateCheckBoxState(widget.cartItemDetail.id, selected);
    if (value) {
      await Provider.of<CartProvider>(context, listen: false)
          .selectCartItem(widget.cartItemDetail.product!.id!);
    } else {
      await Provider.of<CartProvider>(context, listen: false)
          .unselectCartItem(widget.cartItemDetail.product!.id!);
    }
  }

  Future<void> deleteCartItem(BuildContext context) async {
    await Provider.of<CartProvider>(context, listen: false)
        .updateCart(widget.cartItemDetail.product!.id!, 0);
  }

  void moveToWishlist(BuildContext context) async {
    final wishlist = await handleFutureFunction(context,
        successMessage: "Product moved to wishlist",
        function: Provider.of<WishlistProvider>(context, listen: false)
            .addWishlist(widget.cartItemDetail.product!.id!));
    if (wishlist != null && context.mounted) {
      await deleteCartItem(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.cartItemDetail.product;

    if (loading || product == null) {
      return const ListTile(
        title: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              value: selected,
              onChanged: (value) => toggleCartItem(context, value!),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ViewProductPage.routeName,
                  arguments: product.id!,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: product.images![0],
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (_, __, downloadProgress) =>
                              Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name!,
                            style: theme.textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            rupiahFormatter.format(product.price),
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(children: [
            GestureDetector(
              onTap: () => moveToWishlist(context),
              child: Text("Move To Wishlist",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.black54)),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => deleteCartItem(context),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.black54,
              ),
              iconSize: 20,
            ),
            QuantityField(
              controller: _quantityController,
              focusNode: _quantityFocus,
              maximum: product.stock!,
              minimum: 1,
              onDecrease: () => removeFromCart(context),
              onIncrease: () => addToCart(context),
            ),
          ]),
        )
      ],
    );
  }
}
