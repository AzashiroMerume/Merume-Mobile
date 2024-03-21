import 'package:realm/realm.dart';
import 'package:merume_mobile/local_db/models/channel_last_scroll_position_model.dart';

class ChannelLastScrollPositionRepository {
  static Realm? _realmInstance;
  static Configuration? _config;

  static void _initializeRealm() {
    _config ??= Configuration.local([ChannelLastScrollPosition.schema]);
    _realmInstance ??= Realm(_config!);
  }

  static void _closeRealm() {
    _realmInstance?.close();
    _realmInstance = null;
    _config = null;
  }

  static void writePosition(String channelId, double position) {
    _initializeRealm();
    final result = _realmInstance!.find<ChannelLastScrollPosition>(channelId);
    if (result != null) {
      _realmInstance!.write(() => result.lastPosition = position);
    } else {
      final model = ChannelLastScrollPosition(channelId, position);
      _realmInstance!.write(() => _realmInstance!.add(model));
    }

    _closeRealm();
  }

  static double? readPosition(String channelId) {
    _initializeRealm();
    final result = _realmInstance!.find<ChannelLastScrollPosition>(channelId);
    final lastPosition = result?.lastPosition;

    _closeRealm();

    return lastPosition;
  }
}
