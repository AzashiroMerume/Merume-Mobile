import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';
import 'package:merume_mobile/screens/settings/preferences_screen.dart';
import 'package:merume_mobile/api/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final isAuthenticated = await verifyAuth();
    runApp(MyApp(isAuthenticated: isAuthenticated));
  } catch (e) {
    print(e);
    runApp(const MyApp(isAuthenticated: false));
  }
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({super.key, required this.isAuthenticated});

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
      // initialRoute: '/preferences',
      home: isAuthenticated ? const MainScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
