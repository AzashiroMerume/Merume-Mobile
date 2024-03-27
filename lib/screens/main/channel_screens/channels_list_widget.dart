import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_screen.dart';

class ChannelItem extends StatelessWidget {
  final Channel channel;

  const ChannelItem({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChannelScreen(channel: channel),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: 100.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lavenderHaze.withOpacity(0.5)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.0,
                  child: ClipOval(
                    child: channel.channelProfilePictureUrl != null
                        ? Image.network(
                            channel.channelProfilePictureUrl!,
                            height: 60.0,
                            width: 60.0,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/pfp_outline.png',
                            height: 60.0,
                            width: 60.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  channel.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  channel.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 14.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
