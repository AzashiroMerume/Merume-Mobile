import 'package:realm/realm.dart';

part 'channel_read_tracker_model.g.dart';

@RealmModel()
class _ChannelReadTracker {
  @PrimaryKey()
  late String channelId;

  late int unreadCount;
}
