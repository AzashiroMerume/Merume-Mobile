import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/triangle.dart';

class PostInListWidget extends StatelessWidget {
  final Post post;
  final MessageStatus status;
  final bool isAuthor;
  final bool isSamePost;

  const PostInListWidget({
    Key? key,
    required this.post,
    required this.status,
    required this.isAuthor,
    required this.isSamePost,
  }) : super(key: key);

  String formatPostDate(DateTime postDate) {
    final now = DateTime.now();
    final fullDateFormat = DateFormat("dd MMM yyyy");
    final postDateFormat = DateFormat("dd MMM");
    if (now.year == postDate.year &&
        now.month == postDate.month &&
        now.day == postDate.day) {
      // Post was sent today
      return 'Today';
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      if (yesterday.year == postDate.year &&
          yesterday.month == postDate.month &&
          yesterday.day == postDate.day) {
        // Post was sent yesterday
        return 'Yesterday';
      } else if (now.year == postDate.year) {
        // Show the date without the year
        return postDateFormat.format(postDate).toString();
      } else {
        // Show the full date with the year
        return fullDateFormat.format(postDate).toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeDateFormat = DateFormat("HH:mm");
    final timeDate = timeDateFormat.format(post.createdAt).toString();
    final fullDate = formatPostDate(post.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          if (!isSamePost)
            Column(
              children: [
                Text(
                  fullDate,
                  style: const TextStyle(
                    color: AppColors.lavenderHaze,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          Row(
            mainAxisAlignment:
                isAuthor ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isAuthor) CustomPaint(painter: Triangle(Colors.grey[900]!)),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.postMain,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 300.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.username,
                      style: const TextStyle(
                        color: AppColors.mellowLemon,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      post.body!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Day ${post.writtenChallengeDay}",
                          style: const TextStyle(
                            color: AppColors.lavenderHaze,
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        const Text(
                          "|",
                          style: TextStyle(
                            color: AppColors.lavenderHaze,
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          timeDate, // Display the formatted date
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
        ],
      ),
    );
  }
}
