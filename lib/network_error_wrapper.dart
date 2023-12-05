import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/network_error_popup_widget.dart';

class NetworkErrorWrapper extends StatefulWidget {
  final Widget child;

  const NetworkErrorWrapper({super.key, required this.child});

  @override
  NetworkErrorWrapperState createState() => NetworkErrorWrapperState();
}

class NetworkErrorWrapperState extends State<NetworkErrorWrapper> {
  bool? isConnected;
  late Timer _connectivityTimer; // Add a Timer variable

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    // Initialize the timer and store it in the variable
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
    _connectivityTimer.cancel(); // Cancel the timer in dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Or any loading indicator
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please turn on your wifi or mobile data',
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            duration: Duration(seconds: 10),
                            backgroundColor: Colors.red,
                          ),
                        );
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
