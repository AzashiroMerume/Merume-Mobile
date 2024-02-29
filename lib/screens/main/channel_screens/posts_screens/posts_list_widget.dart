import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/components/minimized_pfp_widget.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/components/message_bubble_widget.dart';

class PostsInListWidget extends StatelessWidget {
  final List<PostSent> postList;
  final DateTime sentDay;
  final bool byMe;

  const PostsInListWidget({
    super.key,
    required this.postList,
    required this.sentDay,
    required this.byMe,
  });

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
              final isFirstMessage = postList.indexOf(postSent) == 0;
              final isLastMessage =
                  postList.indexOf(postSent) == postList.length - 1;
              final listIsNotSingleElement = postList.length > 1;
              return GestureDetector(
                onLongPress: () {
                  print("Post ID: ${postSent.post.id} is pressed for a while.");
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 7.5),
                  child: Column(
                    children: [
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
                                          painter: MessageBubble(
                                              Colors.grey[900]!,
                                              direction: false),
                                        ),
                                      ],
                                    )
                                  : const Row(
                                      children: [],
                                    ),
                            ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: byMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.postMain,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  width: 300.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isFirstMessage)
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                    AlwaysStoppedAnimation<
                                                            Color>(
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
                                              Colors.grey[900]!,
                                              direction: true),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        buildMinimizedPfp(postSent.post, 30),
                                      ],
                                    )
                                  : const Row(
                                      children: [],
                                    ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
