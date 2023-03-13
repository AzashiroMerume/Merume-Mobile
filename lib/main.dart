import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';

void main() {
  runApp(MaterialApp(
    home: const DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
      ),
      child: StartScreen(),
    ),
    routes: {
      '/login': (context) => LoginScreen(),
    },
  ));
}
