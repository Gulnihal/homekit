import 'package:flutter/material.dart';
import 'package:homekit_app/pages/account/screens/account_settings.dart';
import 'package:homekit_app/pages/account/services/account_services.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void navigateToAccountSettings() {
    Navigator.pushNamed(context, AccountSettings.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColor,
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    navigateToAccountSettings();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    AccountServices().logOut(context);
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Hi ${user.username} ",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '😊', // Smile emoji
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 35,
                      ), // Adjust emoji if needed
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
          ],
        ),
      ),
    );
  }
}
