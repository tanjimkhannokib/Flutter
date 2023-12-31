import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/domains/entities/category.dart';
import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/presentation/helper_variables/search_arguments.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/home_appbar.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:campusepsilon/presentation/pages/features/product/widgets/filter_bottom_sheet.dart';
import 'package:campusepsilon/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:campusepsilon/presentation/providers/product_provider.dart';

class SearchProductPage extends StatefulWidget {
  static const routeName = "/products/search";

  final SearchArguments searchArguments;

  const SearchProductPage({super.key, required this.searchArguments});

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  late SearchArguments _searchArguments;
  Set<Category>? _categorySelection;
  late final _searchProduct =
      Provider.of<ProductProvider>(context, listen: false).searchProduct;

  @override
  void initState() {
    super.initState();
    _searchArguments = widget.searchArguments;
  }

  Future<void> showFilterOptions(BuildContext context) async {
    _categorySelection ??= Provider.of<ProductProvider>(context, listen: false)
        .getSearchedProductCategories();

    SearchArguments? searchArguments = await showFilterBottomSheet(context,
        searchArguments: _searchArguments,
        categorySelection: _categorySelection!);
    FocusManager.instance.primaryFocus
        ?.unfocus(); // to fix autofocused on search textfield https://github.com/flutter/flutter/issues/54277

    if (searchArguments != null) {
      searchArguments = searchArguments.copyWith(searchQuery: _searchArguments.searchQuery);
      setState(() {
        _searchArguments = searchArguments!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(query: widget.searchArguments.searchQuery ?? ""),
      body: RefreshIndicator(
        onRefresh: () => _searchProduct(_searchArguments),
        child: Padding(
          padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
          child: FutureBuilder(
              future: _searchProduct(_searchArguments),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final products = snapshot.data!;

                  if (products.isEmpty) {
                    return const SingleChildFullPageScrollView(
                        child: Text(
                            "Product not found... Try another keyword"));
                  }

                  return MasonryGridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final Product product = products[index];
                      return SingleProductCard(product: product);
                    },
                  );
                } else if (snapshot.hasError) {
                  return SingleChildFullPageScrollView(
                      child: Text('${snapshot.error}'));
                }
                return const SingleChildFullPageScrollView.loading();
              }),
        ),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () => showFilterOptions(context),
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text("Sort & Filter"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
