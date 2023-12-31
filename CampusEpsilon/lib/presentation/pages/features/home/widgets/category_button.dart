import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:campusepsilon/domains/entities/category.dart';
import 'package:campusepsilon/presentation/helper_variables/search_arguments.dart';
import 'package:campusepsilon/presentation/pages/features/product/search_product_page.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(SearchProductPage.routeName,
          arguments: SearchArguments(category: category)),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: category.image!,
            height: 30,
            width: 30,
            progressIndicatorBuilder: (_, __, downloadProgress) => Center(
                child: CircularProgressIndicator(
                    value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              category.name!,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
