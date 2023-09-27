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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: AppColors.postMain,
              borderRadius: BorderRadius.circular(
                  10.0), // Adjust the corner radius as needed
            ),
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${post.ownerNickname}',
                  style: const TextStyle(
                    color: AppColors.mellowLemon,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  post.body,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isError)
                      const Icon(
                        Icons.error_outline_outlined,
                        color: Colors.red,
                        size: 20.0,
                      )
                    else
                      const Icon(
                        Icons.done,
                        color: AppColors.lavenderHaze,
                        size: 20.0,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }
}
