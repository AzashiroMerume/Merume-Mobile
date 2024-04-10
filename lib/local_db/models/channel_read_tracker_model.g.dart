// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_read_tracker_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ChannelReadTracker extends _ChannelReadTracker
    with RealmEntity, RealmObjectBase, RealmObject {
  ChannelReadTracker(
    String channelId,
    int unreadCount,
  ) {
    RealmObjectBase.set(this, 'channelId', channelId);
    RealmObjectBase.set(this, 'unreadCount', unreadCount);
  }

  ChannelReadTracker._();

  @override
  String get channelId =>
      RealmObjectBase.get<String>(this, 'channelId') as String;
  @override
  set channelId(String value) => RealmObjectBase.set(this, 'channelId', value);

  @override
  int get unreadCount => RealmObjectBase.get<int>(this, 'unreadCount') as int;
  @override
  set unreadCount(int value) => RealmObjectBase.set(this, 'unreadCount', value);

  @override
  Stream<RealmObjectChanges<ChannelReadTracker>> get changes =>
      RealmObjectBase.getChanges<ChannelReadTracker>(this);

  @override
  ChannelReadTracker freeze() =>
      RealmObjectBase.freezeObject<ChannelReadTracker>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ChannelReadTracker._);
    return const SchemaObject(
        ObjectType.realmObject, ChannelReadTracker, 'ChannelReadTracker', [
      SchemaProperty('channelId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('unreadCount', RealmPropertyType.int),
    ]);
  }
}
