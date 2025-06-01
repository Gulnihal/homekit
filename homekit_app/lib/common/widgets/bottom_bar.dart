import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/pages/home/screens/home_screen.dart';
import 'package:homekit_app/pages/notifications/screens/notifications_screen.dart';
import 'package:homekit_app/pages/account/screens/account_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;

  List<Widget> pages = [
    const HomeScreen(),
    NotificationsScreen(),
    const AccountScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.buttonBackgroundColor,
        unselectedItemColor: GlobalVariables.buttonBackgroundColor,
        backgroundColor: GlobalVariables.fieldBackgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // HOME
          BottomNavigationBarItem(
            icon: Container(
              width: MediaQuery.of(context).size.width/10,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.buttonBackgroundColor
                        : GlobalVariables.fieldBackgroundColor,
                    width: MediaQuery.of(context).size.width/100,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // NOTIFICATIONS
          BottomNavigationBarItem(
            icon: Container(
              width: MediaQuery.of(context).size.width/10,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.buttonBackgroundColor
                        : GlobalVariables.fieldBackgroundColor,
                    width: MediaQuery.of(context).size.width/100,
                  ),
                ),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
              ),
            ),
            label: '',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: MediaQuery.of(context).size.width/10,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.buttonBackgroundColor
                        : GlobalVariables.fieldBackgroundColor,
                    width: MediaQuery.of(context).size.width/100,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
