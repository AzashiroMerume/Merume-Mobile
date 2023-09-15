import 'package:flutter/material.dart';

import 'package:merume_mobile/api/auth_api/logout.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              final loggedOut = await logout();
              if (loggedOut) {
                // Navigate to the login screen
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text("Log out"),
          ),
        ),
      ),
    );
  }
}
