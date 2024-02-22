import 'dart:convert';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/auth_api/firebase_auth_api.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/other/firebase_options.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_tab_bar_screen.dart';
import 'package:merume_mobile/network_checking/network_wrapper.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/user_provider.dart';
import 'package:provider/provider.dart';

const storage = FlutterSecureStorage();

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
    isAuthenticated = await verifyAuthInFirebase();
  } catch (e) {
    if (kDebugMode) {
      print('Error in verifyAuthInFirebase: $e');
    }
    isAuthenticated = false;
  }

  if (isAuthenticated) {
    final userInfoJson = await storage.read(key: 'userInfo');
    if (userInfoJson != null) {
      final Map<String, dynamic> userInfoMap = jsonDecode(userInfoJson);
      user = User.fromJson(userInfoMap);
    }
  }

  final userProvider = UserProvider();
  userProvider.setUser(user);

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
      home: NetworkWrapper(
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
