import 'package:flutter/material.dart';
import 'package:merume_mobile/models/user_info_model.dart';

//class for provider
class UserInfoProvider extends ChangeNotifier {
  UserInfo? _userInfo;

  UserInfo? get userInfo => _userInfo;

  void setUserInfo(UserInfo? user) {
    _userInfo = user;
    notifyListeners();
  }
}
