import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/presentation/helper_variables/format_tk.dart';
import 'package:campusepsilon/domains/entities/address.dart';
import 'package:campusepsilon/presentation/helper_variables/future_function_handler.dart';
import 'package:campusepsilon/presentation/pages/features/cart/widgets/address_selection_bottom_sheet.dart';
import 'package:campusepsilon/presentation/pages/features/cart/widgets/checkout_item_tile.dart';
import 'package:campusepsilon/presentation/pages/features/home/home_page.dart';
import 'package:campusepsilon/presentation/pages/features/order/view_order_page.dart';
import 'package:campusepsilon/presentation/providers/cart_provider.dart';
import 'package:campusepsilon/presentation/providers/order_provider.dart';
import 'package:campusepsilon/presentation/providers/user_provider.dart';
import 'package:campusepsilon/presentation/pages/features/address/view_all_addresses_page.dart'; // Import the ViewAllAddressesPage class

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Address selectedAddress = Address(
      id: '',
      owner: null,
      label: '',
      completeAddress: '',
      notes: '',
      receiverName: '',
      receiverPhone: '',
      createdAt: null,
      updatedAt: null,
      v: null); // Provide an initial value

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final defaultAddress = userProvider.user?.defaultAddress;

    if (defaultAddress != null) {
      selectedAddress = defaultAddress;
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Default Address Not Found"),
              content: const Text("Please add a default address."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context)
                        .pushReplacementNamed(ViewAllAddressesPage.routeName);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      });
    }
  }

  Future<void> checkout(BuildContext context) async {
    final order = await handleFutureFunction(
      context,
      successMessage: "Order created. Pay to complete order",
      function: Provider.of<OrderProvider>(context, listen: false)
          .checkOut(selectedAddress.id!),
    );
    if (order != null && context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
      Navigator.of(context)
          .pushNamed(ViewOrderPage.routeName, arguments: order.id!);
    }
  }

  Future<void> showAddressSelection(BuildContext context) async {
    final address = await showAddressSelectionBottomSheet(context,
        selectedAddress: selectedAddress);
    if (address != null) {
      setState(() {
        selectedAddress = address;
      });
    }
  }

  Widget _buildAddressSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shipping Address", style: theme.textTheme.titleMedium),
              GestureDetector(
                onTap: () => showAddressSelection(context),
                child: Text("Choose Other Address",
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: theme.primaryColor)),
              ),
            ],
          ),
          const Divider(thickness: 0),
          Text(selectedAddress.label!, style: theme.textTheme.titleSmall),
          Text(
              "${selectedAddress.receiverName} (${selectedAddress.receiverPhone})"),
          Text(selectedAddress.completeAddress!)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart =
        Provider.of<CartProvider>(context, listen: false).getCheckoutCart();
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"),backgroundColor: Colors.green,),
      body: Column(
        children: [
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 10),
              separatorBuilder: (context, index) => const Divider(thickness: 5),
              itemCount: cart.cartItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildAddressSection(context);

                index--;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ${index + 1}",
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      CheckoutItemTile(cartItem: cart.cartItems[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
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
            child:
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Invoice", style: theme.textTheme.titleSmall),
                      Text(
                        rupiahFormatter.format(cartProvider.totalPrice),
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        textStyle: theme.textTheme.titleMedium),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Checkout"),
                    ),
                    onPressed: () => checkout(context),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
