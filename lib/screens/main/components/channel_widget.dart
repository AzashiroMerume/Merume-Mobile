import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/models/channel_model.dart';

class ChannelWidget extends StatelessWidget {
  final Channel channel;

  const ChannelWidget({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 300.0,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            channel.name, // Use the channel's name or relevant property here
            style: const TextStyle(
              color: AppColors.mellowLemon,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
