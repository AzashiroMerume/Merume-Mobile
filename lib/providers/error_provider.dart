import 'dart:async';
import 'package:flutter/material.dart';

class ErrorProvider extends ChangeNotifier {
  bool _showError = false;
  String _errorMessage = '';
  int _retrySeconds = 0;
  Timer? _retryTimer;

  bool get showError => _showError;
  String get errorMessage => _errorMessage;
  int get retrySeconds => _retrySeconds;

  void setError([int? retrySeconds, String? message]) {
    _showError = true;
    _errorMessage = message ?? 'Oops! Something went wrong.';
    _retrySeconds = retrySeconds ?? 15;
    notifyListeners();

    _startRetryTimer();
  }

  void clearError() {
    _showError = false;
    _errorMessage = '';
    _retrySeconds = 0;
    if (_retryTimer != null) {
      _retryTimer?.cancel();
    }
    notifyListeners();
  }

  void _startRetryTimer() {
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_retrySeconds > 0) {
        _retrySeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }
}
