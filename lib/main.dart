import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';

void main() {
  runApp(MaterialApp(
    // initialRoute: '/register',
    home: const DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
      ),
      child: StartScreen(),
    ),
    routes: {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
    },
  ));
}
