import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_screen.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/screens/settings/preferences_screen.dart';
import 'package:merume_mobile/api/auth_api.dart';
// import 'package:flutter/services.dart';

import 'exceptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top]);

  bool isAuthenticated = false;
  String errorMessage = '';

  try {
    isAuthenticated = await verifyAuth();
  } on PreferencesUnsetException {
    runApp(const MyApp(
      isAuthenticated: true,
      navigateToPreferences: true,
    ));
    return;
  } catch (e) {
    errorMessage = 'There was an error on the server side';
  }

  runApp(MyApp(
    isAuthenticated: isAuthenticated,
    errorMessage: errorMessage,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool navigateToPreferences;
  final String errorMessage;

  const MyApp({
    Key? key,
    required this.isAuthenticated,
    this.navigateToPreferences = false,
    this.errorMessage = '',
  }) : super(key: key);

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
      home: Scaffold(
        body: navigateToPreferences
            ? const PreferencesScreen()
            : isAuthenticated
                ? const MainScreen()
                : const StartScreen(),
        bottomNavigationBar:
            errorMessage != '' ? SnackbarWidget(message: errorMessage) : null,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class SnackbarWidget extends StatelessWidget {
  final String message;

  const SnackbarWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));
  }
}
