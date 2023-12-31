import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:campusepsilon/presentation/helper_variables/format_tk.dart';
import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/presentation/pages/features/product/view_product_page.dart';
import 'package:campusepsilon/presentation/pages/features/product/widgets/wishlist_action_buttons.dart';

class SingleProductCard extends StatelessWidget {
  const SingleProductCard(
      {Key? key, required this.product, this.isWishlist = false})
      : super(key: key);

  final Product product;
  final bool isWishlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(ViewProductPage.routeName, arguments: product.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: CachedNetworkImage(
                imageUrl: product.images![0],
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(
                    rupiahFormatter.format(product.price),
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  const SizedBox(height: 3),
                  if (product.averageRating != null ||
                      (product.totalSold != null && product.totalSold! > 0))
                    SizedBox(
                      height: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (product.averageRating != null) ...[
                            Icon(
                              Icons.star_rounded,
                              color: theme.primaryColor,
                              size: 20,
                            ),
                            Text(
                              product.averageRating!.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.black54),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            ),
                          ],
                          if (product.totalSold != null &&
                              product.totalSold! > 0)
                            Text(
                              "Sold ${NumberFormat.compact().format(product.totalSold)}",
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.black54),
                            ),
                        ],
                      ),
                    ),
                  if (isWishlist) WishlistActionButtons(productId: product.id!)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
