import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';
import 'package:merume_mobile/api/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final isAuthenticated = await verifyAuth();
    runApp(MyApp(isAuthenticated: isAuthenticated));
  } catch (e) {
    runApp(MyApp(errorMessage: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  final bool? isAuthenticated;
  final String? errorMessage;

  const MyApp({super.key, this.isAuthenticated, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merume',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: errorMessage != null
          ? LoginScreen(errorMessage: errorMessage!)
          : isAuthenticated!
              ? const MainScreen()
              : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
