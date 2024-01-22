import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/screens/components/last_time_online.dart';
import 'package:merume_mobile/user_provider.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: true).userInfo;

    if (user == null) {
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
      appBar: AppBar(
        title: Text(
          user.nickname,
          style: const TextStyle(
              fontFamily: 'Poppins', color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
      ),
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
                backgroundImage: user.pfpLink != null
                    ? NetworkImage(user.pfpLink!)
                    : const AssetImage('assets/images/pfp_outline.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 20.0),
              Text(
                user.username,
                style: const TextStyle(
                    fontSize: 24.0,
                    color: AppColors.mellowLemon,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans'),
              ),
              const SizedBox(height: 5.0),
              Text(
                '@${user.nickname}',
                style: const TextStyle(
                    fontSize: 18.0,
                    color: AppColors.lightGrey,
                    fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 5.0),
              if (user.isOnline)
                const Text(
                  'Online',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontFamily: 'Poppins'),
                )
              else
                Text(
                  formatLastSeen(user.lastTimeOnline),
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontFamily: 'Poppins'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
