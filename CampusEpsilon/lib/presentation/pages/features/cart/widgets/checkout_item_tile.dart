import 'package:flutter/material.dart';
import 'package:campusepsilon/presentation/helper_variables/format_tk.dart';
import 'package:campusepsilon/domains/entities/cart_item.dart';
import 'package:campusepsilon/presentation/pages/features/cart/widgets/checkout_item_detail_tile.dart';

class CheckoutItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CheckoutItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = cartItem.cartItemDetails!
        .map<int>((e) => e.quantity! * e.product!.price!)
        .reduce((value, element) => value + element);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${cartItem.seller?.name}",
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
          const Divider(
            thickness: 0,
            height: 20,
          ),
          itemCount: cartItem.cartItemDetails!.length,
          itemBuilder: (context, index) {
            final cartItemDetail = cartItem.cartItemDetails![index];
            return CheckoutItemDetailTile(cartItemDetail: cartItemDetail);
          },
        ),
        const Divider(thickness: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal", style: theme.textTheme.bodyLarge),
            Text(
              rupiahFormatter.format(subtotal),
              style: theme.textTheme.titleMedium,
            ),
          ],
        )
      ],
    );
  }
}
