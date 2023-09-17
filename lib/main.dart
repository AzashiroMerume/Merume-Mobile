import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_tab_bar_screen.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/settings/preferences_screen.dart';
import 'package:merume_mobile/api/auth_api/verify_auth.dart';
import 'exceptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isAuthenticated = false;

  try {
    isAuthenticated = await verifyAuth();
  } on PreferencesUnsetException {
    runApp(const MyApp(
      isAuthenticated: true,
      navigateToPreferences: true,
    ));
    return;
  }

  runApp(MyApp(
    isAuthenticated: isAuthenticated,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool navigateToPreferences;

  const MyApp({
    Key? key,
    required this.isAuthenticated,
    this.navigateToPreferences = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merume',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
          shape: Border(
            bottom: BorderSide(
              color: AppColors.lavenderHaze.withOpacity(0.5),
              width: 1.0,
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        body: navigateToPreferences
            ? const PreferencesScreen()
            : isAuthenticated
                ? const MainTabBarScreen()
                : const StartScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/main': (context) => const MainTabBarScreen(),
      },
    );
  }
}
