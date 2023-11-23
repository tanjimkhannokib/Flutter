import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:campusepsilon/injection.dart' as di;
import 'notes/Models/NoteModels.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/product_search_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:provider/provider.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/seller_navigation_bar.dart';
import 'package:campusepsilon/presentation/pages/features/auth/auth_page.dart';
import 'package:campusepsilon/presentation/pages/common_widgets/buyer_navigation_bar.dart';
import 'package:campusepsilon/presentation/providers/address_provider.dart';
import 'package:campusepsilon/presentation/providers/category_provider.dart';
import 'package:campusepsilon/presentation/providers/cart_provider.dart';
import 'package:campusepsilon/presentation/providers/order_item_provider.dart';
import 'package:campusepsilon/presentation/providers/order_provider.dart';
import 'package:campusepsilon/presentation/providers/product_provider.dart';
import 'package:campusepsilon/presentation/providers/review_provider.dart';
import 'package:campusepsilon/presentation/providers/user_provider.dart';
import 'package:campusepsilon/presentation/providers/local_settings_provider.dart';
import 'package:campusepsilon/presentation/providers/wishlist_provider.dart';
import 'package:campusepsilon/routing.dart';
import 'notes/notehome.dart';


Future<void> main() async {
  di.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteModelsAdapter());
  await Hive.openBox<NoteModels>('Note');

  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<UserProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<CategoryProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalSettingsProvider(),
        ),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
          create: (_) => di.locator<ProductProvider>(),
          update: (_, value, __) =>
              di.locator<ProductProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => di.locator<CartProvider>(),
          update: (_, value, previousCartProvider) {
            final cartProvider =
            di.locator<CartProvider>(param1: value.user?.token);
            cartProvider.cart = previousCartProvider?.cart;
            if (cartProvider.cart == null) {
              cartProvider.init(); // fetch cart immediately
            }
            return cartProvider;
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderProvider>(
          create: (_) => di.locator<OrderProvider>(),
          update: (_, value, __) =>
              di.locator<OrderProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, WishlistProvider>(
          create: (_) => di.locator<WishlistProvider>(),
          update: (_, value, __) =>
              di.locator<WishlistProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, OrderItemProvider>(
          create: (_) => di.locator<OrderItemProvider>(),
          update: (_, value, __) =>
              di.locator<OrderItemProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProxyProvider<UserProvider, AddressProvider>(
          create: (_) => di.locator<AddressProvider>(),
          update: (_, value, previousAddressProvider) =>
          di.locator<AddressProvider>(param1: value.user?.token)
            ..addressesList = previousAddressProvider?.addressesList,
        ),
        ChangeNotifierProxyProvider<UserProvider, ReviewProvider>(
          create: (_) => di.locator<ReviewProvider>(),
          update: (_, value, previousAddressProvider) =>
              di.locator<ReviewProvider>(param1: value.user?.token),
        ),
        ChangeNotifierProvider(
          create: (_) => StartButtonProvider(),
        ),
      ],
      child: Consumer<StartButtonProvider>(
        builder: (context, startButtonProvider, child) {
          final showButton = startButtonProvider.showButton;
          return FlutterWebFrame(
            builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'CAMPUSEPSILON',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.lightGreen,
                ),
              ),
              home: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: const Color(0xFFFDFDF5), // White background color
                body: showButton
                    ? SingleChildScrollView(
                      child: Column(
                  children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: NoteApp(), // Replace with your NoteApp widget
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ProductSearchBar(), // Replace with your NoteApp widget
                    ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ), // Set the height for the SizedBox
                    ElevatedButton(
                      onPressed: () {
                        startButtonProvider.startMainProgram();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: const Color(0xff216106),
                        shadowColor: Color(0xff216106), // Color of the shadow
                        elevation: 10, // Depth of the shadow
                      ),
                      child: const Text(
                        "Shop Time",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                    )
                    : Builder(
                  builder: (context) {
                    // Providers will start working when the button is clicked
                    final userProvider =
                    Provider.of<UserProvider>(context);
                    final localSettingsProvider =
                    Provider.of<LocalSettingsProvider>(context);

                    final user = userProvider.user;
                    Widget currentWidget;
                    final isLoggedIn =
                        user != null &&
                            user.token != null &&
                            user.token!.isNotEmpty;

                    if (localSettingsProvider.appMode ==
                        AppMode.buyer) {
                      if (isLoggedIn) {
                        currentWidget = const BuyerNavBar();
                      } else {
                        currentWidget = const AuthPage();
                      }
                    } else if (localSettingsProvider.appMode ==
                        AppMode.guest) {
                      currentWidget = const BuyerNavBar();
                    } else if (localSettingsProvider.appMode ==
                        AppMode.seller) {
                      if (isLoggedIn) {
                        currentWidget = const SellerNavBar();
                      } else {
                        currentWidget = const AuthPage();
                      }
                    } else {
                      currentWidget = const BuyerNavBar();
                    }

                    return currentWidget;
                  },
                ),
              ),
              onGenerateRoute: generateRoute,
            ),
            maximumSize: const Size(475.0, 812.0),
            enabled: kIsWeb,
            backgroundColor: Colors.grey,
          );
        },
      ),
    );
  }
}

class StartButtonProvider extends ChangeNotifier {
  bool showButton = true;

  void startMainProgram() {
    showButton = false;
    notifyListeners();
  }
}


