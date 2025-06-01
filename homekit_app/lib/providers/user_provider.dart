import 'package:flutter/material.dart';
import 'package:homekit_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    token: '',
    id: '',
    username: '',
    email: '',
    password: '',
    device: null,
  );

  bool _isLoading = true;
  User get user => _user;
  bool get isLoading => _isLoading;

  void setUser(String userJson) {
    _user = User.fromJson(userJson);
    _isLoading = false;
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
