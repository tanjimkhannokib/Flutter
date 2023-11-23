import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart'; // Import the shake package
import 'package:campusepsilon/presentation/helper_variables/future_function_handler.dart';
import 'package:campusepsilon/presentation/pages/features/address/view_all_addresses_page.dart';
import 'package:campusepsilon/presentation/pages/features/user/edit_user_page.dart';
import 'package:campusepsilon/presentation/providers/local_settings_provider.dart';
import 'package:campusepsilon/presentation/providers/user_provider.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../../notes/notehome.dart';

class UserPage extends StatefulWidget {
  static const String routeName = "/users";

  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();

    // Initialize shake detector
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // Show the developer info dialog when the phone is shaken
        _showDeveloperInfoDialog();
      },
    );
  }

  @override
  void dispose() {
    // Dispose of the shake detector
    _shakeDetector?.stopListening();
    super.dispose();
  }

  Future<void> logout(BuildContext context) async {
    await handleFutureFunction(
      context,
      function: Provider.of<UserProvider>(context, listen: false).logout(),
      loadingMessage: "Logging out...",
      successMessage: "Logged out",
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Confirmation"),
        content: Text("Do you want to exit the app?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              // You can add any additional logic here before exiting.
              Navigator.of(context).pop(true);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showDeveloperInfoDialog() {
    // Show the developer info dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Developer Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your photo in a round circle
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/dev/tanj.jpg'), // Replace with the path to your photo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Add your name
            const Text(
              "Tanjim Khan Nokib",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // Add your institute
            const Text(
              "Daffodil International University",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            // Add your contact number
            Text(
              "Mail: tanjim15-14207@diu.edu.bd",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            // Add your contact number
            Text(
              "Contact: +880 17834 35326",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Account'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Consumer<UserProvider>(
                  builder: (context, value, child) {
                    final user = value.user;
                    if (user == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You are accessing campusepsilon as a guest\n\nLogin to access full feature.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            FilledButton(
                              onPressed: () {
                                Provider.of<LocalSettingsProvider>(context, listen: false)
                                    .switchToBuyerMode();
                              },
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_circle, size: 100),
                            const SizedBox(height: 30),
                            Text(user.name!,
                                style: theme.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                              user.email!,
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Member Since ${DateFormat('d MMMM y').format(user.createdAt!)}",
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(EditUserPage.routeName),
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text("Edit Profile"),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(ViewAllAddressesPage.routeName),
                              icon: const Icon(Icons.home_rounded),
                              label: const Text("Manage Address"),
                            ),
                            const SizedBox(height: 30),
                            TextButton.icon(
                              onPressed: () => logout(context),
                              label: const Text("Logout"),
                              icon: const Icon(Icons.logout_rounded),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                "Shake your device to check the developer information",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Provider.of<LocalSettingsProvider>(context).appMode == AppMode.buyer)
              FilledButton(
                child: const Text("Switch to Seller Mode"),
                onPressed: () => Provider.of<LocalSettingsProvider>(context, listen: false).switchToSellerMode(),
              )
            else if (Provider.of<LocalSettingsProvider>(context).appMode == AppMode.seller)
              FilledButton(
                child: const Text("Switch to Buyer Mode"),
                onPressed: () => Provider.of<LocalSettingsProvider>(context, listen: false).switchToBuyerMode(),
              ),
            const SizedBox(width: 10), // Add some spacing between buttons
            FilledButton(
              child: const Text("Switch to Note Mode"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteApp(), // Replace YourDestinationPage with the actual widget of the page you want to navigate to.
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}


