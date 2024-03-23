import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/wrappers/network_checking/network_error_popup_widget.dart';
import 'package:merume_mobile/utils/error_custom_snackbar.dart';

class NetworkWrapper extends StatefulWidget {
  final Widget child;

  const NetworkWrapper({super.key, required this.child});

  @override
  NetworkWrapperState createState() => NetworkWrapperState();
}

class NetworkWrapperState extends State<NetworkWrapper> {
  bool? isConnected;
  late Timer _connectivityTimer;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _initConnectivity();
    });
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        isConnected = connectivityResult != ConnectivityResult.none;
      });
    }
  }

  @override
  void dispose() {
    _connectivityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return isConnected!
        ? widget.child
        : Scaffold(
            body: Builder(
              builder: (BuildContext scaffoldContext) {
                return NetworkErrorPopupWidget(
                  onPressed: () async {
                    final connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none) {
                      if (context.mounted) {
                        showCustomSnackBar(context,
                            message: 'Please turn on your wifi or mobile data');
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                );
              },
            ),
          );
  }
}
