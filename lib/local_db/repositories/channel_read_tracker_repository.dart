import 'package:merume_mobile/local_db/models/channel_read_tracker_model.dart';
import 'package:merume_mobile/models/read_tracker_model.dart';
import 'package:realm/realm.dart';

class ChannelReadTrackerRepository {
  static Realm? _realmInstance;
  static Configuration? _config;

  static void _initializeRealm() {
    _config ??= Configuration.local([ChannelReadTracker.schema]);
    _realmInstance ??= Realm(_config!);
  }

  static void _closeRealm() {
    _realmInstance?.close();
    _realmInstance = null;
    _config = null;
  }

  static void writeReadTrackers(List<ReadTracker> readTrackers) {
    _initializeRealm();
    for (int i = 0; i < readTrackers.length; i++) {
      final result =
          _realmInstance!.find<ChannelReadTracker>(readTrackers[i].channelId);
      if (result != null) {
        _realmInstance!
            .write(() => result.unreadCount = readTrackers[i].unreadCount);
      } else {
        final model = ChannelReadTracker(
            readTrackers[i].channelId, readTrackers[i].unreadCount);
        _realmInstance!.write(() => _realmInstance!.add(model));
      }
    }

    _closeRealm();
  }

  static List<ReadTracker>? readAllReadTrackers() {
    _initializeRealm();
    final result = _realmInstance!.all<ChannelReadTracker>();

    final resultList = result
        .map((e) =>
            ReadTracker(channelId: e.channelId, unreadCount: e.unreadCount))
        .toList();

    _closeRealm();

    return resultList;
  }
}
