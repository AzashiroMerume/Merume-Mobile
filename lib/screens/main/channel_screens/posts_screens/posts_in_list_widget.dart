import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/minimized_pfp_widget.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/message_bubble_widget.dart';

class PostsInListWidget extends StatelessWidget {
  final List<PostSent> postList;
  final DateTime sentDay;
  final bool byMe;
  final bool shouldShowDate;

  const PostsInListWidget({
    super.key,
    required this.postList,
    required this.sentDay,
    required this.byMe,
    required this.shouldShowDate,
  });

  String formatPostDate(DateTime sentDay) {
    final now = DateTime.now();
    final fullDateFormat = DateFormat("dd MMM yyyy");
    final sentDayFormat = DateFormat("dd MMM");
    if (now.year == sentDay.year &&
        now.month == sentDay.month &&
        now.day == sentDay.day) {
      // Post was sent today
      return 'Today';
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      if (yesterday.year == sentDay.year &&
          yesterday.month == sentDay.month &&
          yesterday.day == sentDay.day) {
        // Post was sent yesterday
        return 'Yesterday';
      } else if (now.year == sentDay.year) {
        // Show the date without the year
        return sentDayFormat.format(sentDay).toString();
      } else {
        // Show the full date with the year
        return fullDateFormat.format(sentDay).toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Wrapping with Center widget to center the content
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: postList.map(
            (postSent) {
              final timeDateFormat = DateFormat("HH:mm");
              final timeDate =
                  timeDateFormat.format(postSent.post.createdAt).toString();
              final fullDate = formatPostDate(sentDay);
              final isLastMessage =
                  postList.indexOf(postSent) == postList.length - 1;
              final listIsNotSingleElement = postList.length > 1;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 7.5),
                child: Column(
                  children: [
                    if (shouldShowDate)
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
                            height: 15.0,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!byMe)
                          Expanded(
                            flex: 1,
                            child: (!byMe && !listIsNotSingleElement) ||
                                    (!byMe &&
                                        listIsNotSingleElement &&
                                        isLastMessage)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildMinimizedPfp(postSent.post, 30),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      CustomPaint(
                                          painter:
                                              MessageBubble(Colors.grey[900]!)),
                                    ],
                                  )
                                : const Row(
                                    children: [],
                                  ),
                          ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                      postSent.post.author.username,
                                      style: const TextStyle(
                                        color: AppColors.mellowLemon,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      postSent.post.body!,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Day ${postSent.post.writtenChallengeDay}",
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
                                        if (postSent.status ==
                                            MessageStatus.error)
                                          const Icon(
                                            Icons.error_outline_outlined,
                                            color: Colors.red,
                                            size: 20.0,
                                          )
                                        else if (postSent.status ==
                                            MessageStatus.waiting)
                                          const SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
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
                            ],
                          ),
                        ),
                        if (byMe)
                          Expanded(
                              flex: 1,
                              child: (byMe && !listIsNotSingleElement) ||
                                      (byMe &&
                                          listIsNotSingleElement &&
                                          isLastMessage)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomPaint(
                                            painter: MessageBubble(
                                                Colors.grey[900]!)),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        buildMinimizedPfp(postSent.post, 30),
                                      ],
                                    )
                                  : const Row(
                                      children: [],
                                    ))
                      ],
                    )
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
