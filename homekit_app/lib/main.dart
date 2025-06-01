import 'package:flutter/material.dart';
import 'package:homekit_app/pages/auth/screens/auth_screen.dart';
import 'package:homekit_app/providers/user_provider.dart';
import 'package:homekit_app/router.dart';
import 'package:provider/provider.dart';
import 'constants/global_variables.dart';
import 'package:homekit_app/pages/auth/services/auth_service.dart';
import 'package:homekit_app/common/widgets/bottom_bar.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.getUserData(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homekit App',
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.fieldColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.fieldColor,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          fontFamily: 'IBMPlexSans',
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.user.token.isEmpty) {
            return const AuthScreen();
          } else {
            return const BottomBar();
          }
        },
      )
    );
  }
}
