import 'package:flutter/material.dart';

class ErrorProvider extends ChangeNotifier {
  bool _showError = false;
  String _errorMessage = '';
  int _retrySeconds = 0;

  bool get showError => _showError;
  String get errorMessage => _errorMessage;
  int get retrySeconds => _retrySeconds;

  void setError([int? retrySeconds, String? message]) {
    _showError = true;
    _errorMessage = message ?? 'Oops! Something went wrong.';
    _retrySeconds = retrySeconds ?? 15;
    notifyListeners();
  }

  void clearError() {
    _showError = false;
    _errorMessage = '';
    _retrySeconds = 0;
    notifyListeners();
  }

  // Function to decrease retrySeconds
  void decreaseRetrySeconds() {
    if (_retrySeconds > 0) {
      _retrySeconds--;
      notifyListeners();
    }
  }
}
