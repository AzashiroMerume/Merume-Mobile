import 'package:flutter/material.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/screens/components/last_time_online.dart';

class OtherUserScreen extends StatefulWidget {
  final User user;

  const OtherUserScreen({super.key, required this.user});

  @override
  State<OtherUserScreen> createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.nickname,
          style: const TextStyle(
              fontFamily: 'Poppins', color: Colors.white, fontSize: 18.0),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: widget.user.pfpLink != null
                      ? NetworkImage(widget.user.pfpLink!)
                      : const AssetImage('assets/images/pfp_outline.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 20.0),
                Text(
                  widget.user.username,
                  style: const TextStyle(
                      fontSize: 24.0,
                      color: AppColors.mellowLemon,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '@${widget.user.nickname}',
                  style: const TextStyle(
                      fontSize: 18.0, color: AppColors.lightGrey),
                ),
                const SizedBox(height: 5.0),
                if (widget.user.isOnline)
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 16.0, color: Colors.green),
                  )
                else
                  Text(
                    formatLastSeen(widget.user.lastTimeOnline),
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
