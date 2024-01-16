import 'package:flutter/material.dart';
import 'package:merume_mobile/models/author_model.dart';

class OtherUserScreen extends StatefulWidget {
  final Author user;

  const OtherUserScreen({super.key, required this.user});

  @override
  State<OtherUserScreen> createState() => _OtherUserScreenState();
}

class _OtherUserScreenState extends State<OtherUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // or CrossAxisAlignment.stretch
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: widget.user.pfpLink != null
                      ? NetworkImage(widget.user.pfpLink!)
                      : const AssetImage('assets/images/pfp_symbol.jpg')
                          as ImageProvider,
                ),
                // Add other widgets as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
