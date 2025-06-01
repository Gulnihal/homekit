import 'package:homekit_app/common/widgets/bottom_bar.dart';
import 'package:homekit_app/pages/auth/screens/auth_screen.dart';
import 'package:homekit_app/pages/account/screens/account_settings.dart';
import 'package:homekit_app/pages/home/screens/home_screen.dart';
import 'package:homekit_app/pages/home/screens/add_device_screen.dart';
import 'package:homekit_app/pages/home/screens/device_screen.dart';
import 'package:homekit_app/models/device.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case AccountSettings.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AccountSettings(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddDevice.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddDevice(),
      );
    case DeviceDetailScreen.routeName:
      var deviceData = routeSettings.arguments as DeviceData;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => DeviceDetailScreen(
          deviceData: deviceData,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
