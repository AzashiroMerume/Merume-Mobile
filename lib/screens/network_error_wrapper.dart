import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/components/network_error_popup_widget.dart';

class NetworkErrorWrapper extends StatefulWidget {
  final Widget child;

  const NetworkErrorWrapper({super.key, required this.child});

  @override
  NetworkErrorWrapperState createState() => NetworkErrorWrapperState();
}

class NetworkErrorWrapperState extends State<NetworkErrorWrapper> {
  late bool isConnected;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? widget.child
        : NetworkErrorPopupWidget(
            onPressed: () async {
              final connectivityResult =
                  await Connectivity().checkConnectivity();
              if (connectivityResult == ConnectivityResult.none) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please turn on your wifi or mobile data'),
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
  }
}
