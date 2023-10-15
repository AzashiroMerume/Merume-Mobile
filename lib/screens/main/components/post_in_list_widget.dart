import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/enums.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/components/triangle.dart';

class PostInListWidget extends StatelessWidget {
  final Post post;
  final MessageStatus status;
  final bool isAuthor;

  const PostInListWidget(
      {Key? key,
      required this.post,
      required this.status,
      required this.isAuthor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("HH:mm");
    final formattedDate = dateFormat.format(post.createdAt).toString();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.5),
      child: Row(
        mainAxisAlignment:
            isAuthor ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isAuthor) CustomPaint(painter: Triangle(Colors.grey[900]!)),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: AppColors.postMain,
              borderRadius: BorderRadius.circular(8.0),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedDate, // Display the formatted date
                      style: const TextStyle(
                        color: AppColors.lavenderHaze,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    if (status == MessageStatus.error)
                      const Icon(
                        Icons.error_outline_outlined,
                        color: Colors.red,
                        size: 20.0,
                      )
                    else if (status == MessageStatus.waiting)
                      const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.lavenderHaze),
                          strokeWidth: 1.0,
                        ),
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
          if (isAuthor) CustomPaint(painter: Triangle(Colors.grey[900]!)),
        ],
      ),
    );
  }
}
