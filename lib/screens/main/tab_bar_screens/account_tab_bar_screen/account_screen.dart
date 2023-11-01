import 'package:flutter/material.dart';

import 'package:merume_mobile/api/auth_api/logout.dart';
import 'package:merume_mobile/user_info.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              final loggedOut = await logout();

              if (loggedOut) {
                userInfoProvider.setUserInfo(null);
                // Navigate to the login screen
                state.pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text("Log out"),
          ),
        ),
      ),
    );
  }
}
