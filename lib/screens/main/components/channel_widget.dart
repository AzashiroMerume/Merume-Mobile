import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

import 'package:merume_mobile/models/channel_model.dart';

class ChannelWidget extends StatelessWidget {
  final Channel channel;

  const ChannelWidget({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Image.asset(
                    'assets/images/isagi.jpg',
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
