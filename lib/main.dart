import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';
import 'package:merume_mobile/api/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize binding

  final isAuthenticated = await verifyAuth();

  runApp(MaterialApp(
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
      ),
      scaffoldBackgroundColor: Colors.black,
    ),
    initialRoute: isAuthenticated ? '/main' : '/start',
    routes: {
      '/start': (context) => const DefaultTextStyle(
            style: TextStyle(
              decoration: TextDecoration.none,
            ),
            child: StartScreen(),
          ),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/main': (context) => const MainScreen(),
    },
  ));
}
