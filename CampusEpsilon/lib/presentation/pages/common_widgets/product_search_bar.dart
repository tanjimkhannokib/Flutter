import 'package:flutter/material.dart';
import 'package:campusepsilon/presentation/helper_variables/search_arguments.dart';
import 'package:campusepsilon/presentation/pages/features/product/search_product_page.dart';

class ProductSearchBar extends StatelessWidget {
  final String query;

  const ProductSearchBar({
    super.key,
    this.query = "",
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: TextFormField(
        initialValue: query,
        onFieldSubmitted: (value) {
          Navigator.of(context).pushNamed(SearchProductPage.routeName,
              arguments: SearchArguments(searchQuery: value));
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search_rounded,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(top: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: 'Search...',
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
