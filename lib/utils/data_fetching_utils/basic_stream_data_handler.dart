import 'dart:async';
import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/utils/navigate_to_login.dart';

typedef FetchFunction<T> = Stream<T> Function();

class BasicStreamDataHandler<T> {
  final BuildContext context;
  final FetchFunction<T> fetchFunction;
  final StreamController<T> controller;
  final ErrorProvider errorProvider;
  final Duration retryTimerDuration;
  final bool addErrorToController;

  Timer? _retryTimer;
  bool _disposed = false;

  BasicStreamDataHandler({
    required this.context,
    required this.fetchFunction,
    required this.controller,
    required this.errorProvider,
    required this.retryTimerDuration,
    this.addErrorToController = true,
  });

  void fetchStreamData() {
    if (_disposed) return;

    fetchFunction().listen(
      (data) {
        if (errorProvider.showError) {
          errorProvider.clearError();
        }

        if (!_disposed && !controller.isClosed) {
          controller.add(data);
        }
      },
      onError: (error) {
        if (!_disposed) {
          handleError(error);
        }
      },
    );
  }

  void handleError(Object error) {
    if (error is TokenErrorException) {
      navigateToLogin(context);
    }

    errorProvider.setError(10);

    _retryTimer?.cancel();

    _retryTimer = Timer(retryTimerDuration, () {
      if (!_disposed && !controller.isClosed) {
        fetchStreamData();
      }
    });

    if (!_disposed && addErrorToController && !controller.isClosed) {
      controller.addError(error);
    }
  }

  void dispose() {
    _disposed = true;
    _retryTimer?.cancel();
  }
}
