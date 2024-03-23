import 'package:flutter/material.dart';
import 'package:merume_mobile/api/auth_api/firebase_auth_api.dart';
import 'package:merume_mobile/api/auth_api/logout_api.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/utils/last_time_online.dart';
import 'package:merume_mobile/providers/user_provider.dart';
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
    final user = Provider.of<UserProvider>(context, listen: true);

    if (user.userInfo == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Oops! Something went wrong.\nPlease try again later.',
            style: TextStyle(fontSize: 18.0, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              CircleAvatar(
                radius: 80.0,
                backgroundImage: user.userInfo?.pfpLink != null
                    ? NetworkImage(user.userInfo!.pfpLink!)
                    : const AssetImage('assets/images/pfp_outline.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 20.0),
              Text(
                user.userInfo!.username, // Use null-aware operator here
                style: const TextStyle(
                  fontSize: 24.0,
                  color: AppColors.mellowLemon,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                '@${user.userInfo!.nickname}', // Use null-aware operator here
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColors.lightGrey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 5.0),
              if (user.userInfo?.isOnline ??
                  false) // Use null-aware operator here
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green,
                    fontFamily: 'Poppins',
                  ),
                )
              else
                Text(
                  formatLastSeen(user.userInfo?.lastTimeOnline),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final loggedOut = await logout();

                    await logoutFromFirebase();

                    if (loggedOut) {
                      user.setUser(null);
                      // Navigate to the login screen
                      state.pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  child: const Text("Log out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
