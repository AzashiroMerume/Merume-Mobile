import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
      ),
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const DefaultTextStyle(
      style: TextStyle(
        decoration: TextDecoration.none,
      ),
      child: StartScreen(),
    ),
    routes: {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/main': (context) => const MainScreen(),
    },
  ));
}
