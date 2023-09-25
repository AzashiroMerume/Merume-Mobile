import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

import 'package:merume_mobile/models/post_model.dart';

class PostInListWidget extends StatelessWidget {
  final Post post;
  final bool isError;

  const PostInListWidget({Key? key, required this.post, required this.isError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.postMain, // Change the background color here
              borderRadius: BorderRadius.circular(
                  10.0), // Adjust the corner radius as needed
            ),
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.body,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8.0), // Add spacing between lines
                if (isError)
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20.0,
                      ),
                      const SizedBox(
                          width: 4.0), // Add spacing between icon and text
                      Text(
                        'Author ID: ${post.ownerId} (Error)',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (!isError)
                  Text(
                    '@${post.ownerNickname}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
