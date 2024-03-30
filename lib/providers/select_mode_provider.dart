import 'package:flutter/material.dart';

class SelectModeProvider extends ChangeNotifier {
  bool _selectModeEnabled = false;

  bool get selectModeEnabled => _selectModeEnabled;

  void setSelectMode(bool value) {
    _selectModeEnabled = value;
    notifyListeners();
  }
}
