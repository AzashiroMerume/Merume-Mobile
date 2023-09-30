import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

import 'package:merume_mobile/screens/auth/login_screen.dart';
import 'package:merume_mobile/screens/auth/register_screen.dart';
import 'package:merume_mobile/screens/main/main_tab_bar_screen.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';
import 'package:merume_mobile/api/auth_api/verify_auth.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? userId;
  bool isAuthenticated = false;
  String errorMessage = '';

  try {
    userId = await verifyAuth();
    isAuthenticated = userId != null;
  } catch (e) {
    errorMessage = 'There was an error on the server side';
  }

  final userInfoProvider = UserInfoProvider();
  if (userId != null) {
    userInfoProvider.setUserInfo(UserInfo(id: userId));
  }

  runApp(
    ChangeNotifierProvider.value(
      value: userInfoProvider,
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
    Key? key,
    required this.isAuthenticated,
    required this.errorMessage,
  }) : super(key: key);

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
      home: Scaffold(
        body: isAuthenticated ? const MainTabBarScreen() : const StartScreen(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainTabBarScreen(),
      },
    );
  }
}
