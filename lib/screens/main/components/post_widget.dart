import 'package:flutter/material.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/models/post_model.dart';

class PostWidget extends StatelessWidget {
  final Channel channel;
  final Post post;

  const PostWidget({Key? key, required this.channel, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color littleLight = const Color(0xFFF3FFAB);

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
            style: TextStyle(
              color: littleLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.body, // Use the post content here
            style: const TextStyle(
              fontFamily: 'WorkSans',
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          // You can add more widgets here for likes, comments, and other actions
        ],
      ),
    );
  }
}
