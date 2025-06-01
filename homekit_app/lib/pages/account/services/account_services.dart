import 'dart:convert';
import 'package:homekit_app/common/widgets/bottom_bar.dart';
import 'package:homekit_app/constants/error_handling.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/constants/utils.dart';
import 'package:homekit_app/pages/auth/screens/auth_screen.dart';
import 'package:homekit_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  late SharedPreferences prefs;

  void updatePassword({
    required BuildContext context,
    required String password,
    required String newPassword,
  }) async {
    try {
      http.Response res = await http.patch(
        Uri.parse('$uri/api/update'),
        body: jsonEncode({
          'password': password,
          'newPassword': newPassword,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context).user.password = newPassword;
          // print(res.body);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
                (route) => false,
          );
        },
      );
      showSnackBar(context, "Password changed!");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteAccount({
    required BuildContext context,
    required String password,
  }) async {
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/delete'),
        body: jsonEncode({
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Navigator.pushNamed(context, AuthScreen.routeName);
        },
      );
      showSnackBar(context, "Account Deleted!");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('accessToken', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
