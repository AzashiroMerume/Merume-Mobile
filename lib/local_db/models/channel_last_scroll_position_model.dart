import 'package:realm/realm.dart';

part 'channel_last_scroll_position_model.g.dart';

@RealmModel()
class _ChannelLastScrollPosition {
  @PrimaryKey()
  late String channelId;

  late double lastPosition;
}
