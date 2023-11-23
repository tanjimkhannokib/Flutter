import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/domains/entities/product.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/home_appbar.dart';
import 'package:campusepsilon/presentation/pages/features/home/widgets/category_button.dart';
import 'package:campusepsilon/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:campusepsilon/presentation/providers/category_provider.dart';
import 'package:campusepsilon/presentation/providers/product_provider.dart';
import 'package:campusepsilon/presentation/helper_variables/provider_state.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      if (Provider.of<ProductProvider>(context, listen: false)
          .getPopularProductsState !=
          ProviderState.loaded ||
          Provider.of<CategoryProvider>(context, listen: false)
              .getAllCategoriesState !=
              ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false).getPopularProducts();
    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: RefreshIndicator(
          onRefresh: () => _fetchData(context),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Discover What You Require",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 70,
                  child: Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        if (categoryProvider.getAllCategoriesState ==
                            ProviderState.loading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (categoryProvider.getAllCategoriesState ==
                            ProviderState.error) {
                          return Center(child: Text(categoryProvider.message));
                        }

                        final categories = categoryProvider.allCategories;

                        if (categories == null || categories.isEmpty) {
                          return const Center(child: Text("Categories not found..."));
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1 / 1.09,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryButton(category: category);
                          },
                        );
                      }),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Popular Products",
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                sliver: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      if (productProvider.getPopularProductsState ==
                          ProviderState.loading) {
                        return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()));
                      }
                      if (productProvider.getPopularProductsState ==
                          ProviderState.error) {
                        return SliverFillRemaining(
                            child: Center(child: Text(productProvider.message)));
                      }

                      final products = productProvider.popularProducts;

                      if (products == null || products.isEmpty) {
                        return const SliverFillRemaining(
                            child: Center(child: Text("Product not found... ")));
                      }

                      return SliverMasonryGrid(
                        delegate: SliverChildBuilderDelegate(
                            childCount: products.length, (context, index) {
                          final Product product = products[index];
                          return SingleProductCard(product: product);
                        }),
                        gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
