import 'package:flutter/material.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_screen.dart';

class ChannelCard extends StatelessWidget {
  final Channel channel;

  const ChannelCard({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.postMain,
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // Handle tap on the channel card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChannelScreen(channel: channel),
            ),
          );
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          leading: CircleAvatar(
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
          ),
          title: Text(
            channel.name,
            style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Poppins',
                color: AppColors.lavenderHaze),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.description,
                style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'WorkSans',
                    color: Colors.white),
              ),
              // const SizedBox(
              //   height: 5.0,
              // ),
              Text(
                'Subscribers: ${channel.followers.currentFollowing.toString()}',
                style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'WorkSans',
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
