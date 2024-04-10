import 'package:flutter/material.dart';
import 'package:merume_mobile/local_db/repositories/channel_read_tracker_repository.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/screens/main/channel_screens/components/channels_item_widget.dart';

class ChannelsList extends StatelessWidget {
  final List<Channel> channels;

  const ChannelsList({
    super.key,
    required this.channels,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: channels.length,
      itemBuilder: (_, index) {
        final channel = channels[index];
        final unreadCount = getUnreadCount(channel.id);
        return ChannelItem(
          channel: channel,
          unreadCount: unreadCount,
        );
      },
    );
  }

  int? getUnreadCount(String channelId) {
    final readTrackers = ChannelReadTrackerRepository.readAllReadTrackers();

    if (readTrackers != null) {
      try {
        return readTrackers
            .firstWhere((element) => element.channelId == channelId)
            .unreadCount;
      } catch (e) {
        // No matching record found for the given channelId
        return null;
      }
    } else {
      return null;
    }
  }
}
