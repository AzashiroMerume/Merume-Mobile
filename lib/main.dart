import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/firebase_options.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_tab_bar_screen.dart';
import 'package:merume_mobile/network_checking/network_error_wrapper.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/api/auth_api/verify_auth.dart';
import 'package:merume_mobile/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  User? user;
  bool isAuthenticated = false;
  String errorMessage = '';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  try {
    user = await verifyAuth();
    isAuthenticated = user != null;
  } catch (e) {
    errorMessage = 'There was an error on the server side';
  }

  final userProvider = UserProvider();
  if (user != null) {
    userProvider.setUser(user);
  } else {
    userProvider.setUser(null);
  }

  runApp(
    ChangeNotifierProvider.value(
      value: userProvider,
      child: MyApp(
        isAuthenticated: isAuthenticated,
        errorMessage: errorMessage,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final String errorMessage;

  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merume',
      debugShowCheckedModeBanner: false,
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
      home: NetworkErrorWrapper(
        child: isAuthenticated ? const MainTabBarScreen() : const StartScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainTabBarScreen(),
      },
    );
  }
}
