import 'package:flutter/material.dart';

class UserInfo {
  final String id;

  UserInfo({
    required this.id,
  });
}

//class for provider
class UserInfoProvider extends ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;

  void setUserInfo(UserInfo user) {
    _userInfo = user;
    notifyListeners();
  }
}
