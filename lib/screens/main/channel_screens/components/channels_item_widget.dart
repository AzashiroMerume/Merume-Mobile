import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_screen.dart';
import 'package:merume_mobile/utils/image_loading.dart';

class ChannelItem extends StatelessWidget {
  final Channel channel;
  final int? unreadCount;

  const ChannelItem({super.key, required this.channel, this.unreadCount});

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
                    child: buildImage(channel.channelPfpLink,
                        'assets/images/pfp_outline.png'),
                  ),
                )
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
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
                  ),
                ],
              ),
            ),
            if (unreadCount != null && unreadCount! > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                width: 20.0,
                height: 20.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentBlue,
                ),
                child: Center(
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: AppColors.mellowLemon,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
