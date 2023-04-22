import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/settings/preferences_screen.dart';
import 'package:merume_mobile/api/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final isAuthenticated = await verifyAuth();
    runApp(MyApp(
      isAuthenticated: isAuthenticated,
      shouldbeStartScreen: true,
    ));
  } catch (e) {
    runApp(const MyApp(
      isAuthenticated: false,
      shouldbeStartScreen: false,
    ));
  }
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool shouldbeStartScreen;

  const MyApp(
      {Key? key,
      required this.isAuthenticated,
      required this.shouldbeStartScreen})
      : super(key: key);

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
      home: shouldbeStartScreen
          ? const StartScreen()
          : isAuthenticated
              ? const MainScreen()
              : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
