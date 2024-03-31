import 'package:flutter/material.dart';
import 'package:merume_mobile/local_db/repositories/channel_last_scroll_position_repository.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/channel_details_screen.dart';

void saveLastScrollPosition(String channelId, double currentPosition) async {
  ChannelLastScrollPositionRepository.writePosition(channelId, currentPosition);
}

void moveToLastScrollPosition(
    String channelId, ScrollController scrollController) async {
  final savedPosition =
      ChannelLastScrollPositionRepository.readPosition(channelId);
  if (scrollController.hasClients) {
    if (savedPosition != null && !savedPosition.isNegative) {
      scrollController.jumpTo(savedPosition);
    } else {
      // check, can throw error
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}

void scrollToNewPost(ScrollController scrollController) {
  if (scrollController.hasClients) {
    final double position = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

void handleAppBarPress(BuildContext context, Channel channel) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChannelDetailsScreen(
        channel: channel,
      ),
    ),
  );
}

AppBar buildDefaultAppBar(String channelName) {
  return AppBar(
    title: Container(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        channelName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    automaticallyImplyLeading: false,
  );
}

AppBar buildPostInteractionAppBar(Function() cancelAction) {
  return AppBar(
    title: Container(
      padding: const EdgeInsets.only(left: 20.0),
      child: const Text(
        "Action",
        style: TextStyle(color: Colors.white),
      ),
    ),
    automaticallyImplyLeading: false,
    actions: [
      TextButton(
        onPressed: () {
          cancelAction();
        },
        child: const Text(
          "CANCEL",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
