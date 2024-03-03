import 'package:flutter/material.dart';
import 'package:merume_mobile/models/user_model.dart';

//class for provider
class UserProvider extends ChangeNotifier {
  User? _userInfo;

  User? get userInfo => _userInfo;

  void setUser(User? user) {
    _userInfo = user;
    notifyListeners();
  }
}
