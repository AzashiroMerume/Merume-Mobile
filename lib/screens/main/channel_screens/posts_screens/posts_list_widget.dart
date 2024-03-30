import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/posts_screens/post_item_widget.dart';

class PostsListWidget extends StatelessWidget {
  final List<PostSent> postList;
  final DateTime sentDay;
  final bool byMe;
  final Function() longPressAction;
  final Function(String) selectPostAction;
  final Function(String) deselectPostAction;

  const PostsListWidget({
    super.key,
    required this.postList,
    required this.sentDay,
    required this.byMe,
    required this.longPressAction,
    required this.selectPostAction,
    required this.deselectPostAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: postList.map(
            (postSent) {
              final isFirstMessage = postList.indexOf(postSent) == 0;
              final isLastMessage =
                  postList.indexOf(postSent) == postList.length - 1;
              final listIsNotSingleElement = postList.length > 1;
              return PostItemWidget(
                postSent: postSent,
                byMe: byMe,
                isFirstMessage: isFirstMessage,
                isLastMessage: isLastMessage,
                listIsNotSingleElement: listIsNotSingleElement,
                longPressAction: longPressAction,
                selectPostAction: selectPostAction,
                deselectPostAction: deselectPostAction,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
