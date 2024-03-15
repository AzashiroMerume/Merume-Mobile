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

  BasicStreamDataHandler({
    required this.context,
    required this.fetchFunction,
    required this.controller,
    required this.errorProvider,
    required this.retryTimerDuration,
    this.addErrorToController = true,
  });

  void fetchStreamData() {
    fetchFunction().listen(
      (data) {
        if (errorProvider.showError) {
          errorProvider.clearError();
        }

        if (!controller.isClosed) {
          controller.add(data);
        }
      },
      onError: (error) {
        handleError(error);
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
      if (!controller.isClosed) {
        fetchStreamData();
      }
    });

    if (addErrorToController && !controller.isClosed) {
      controller.addError(error);
    }
  }

  void dispose() {
    _retryTimer?.cancel();
  }
}
