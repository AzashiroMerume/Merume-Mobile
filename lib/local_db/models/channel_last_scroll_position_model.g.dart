// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_last_scroll_position_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ChannelLastScrollPosition extends _ChannelLastScrollPosition
    with RealmEntity, RealmObjectBase, RealmObject {
  ChannelLastScrollPosition(
    String channelId,
    double lastPosition,
  ) {
    RealmObjectBase.set(this, 'channelId', channelId);
    RealmObjectBase.set(this, 'lastPosition', lastPosition);
  }

  ChannelLastScrollPosition._();

  @override
  String get channelId =>
      RealmObjectBase.get<String>(this, 'channelId') as String;
  @override
  set channelId(String value) => RealmObjectBase.set(this, 'channelId', value);

  @override
  double get lastPosition =>
      RealmObjectBase.get<double>(this, 'lastPosition') as double;
  @override
  set lastPosition(double value) =>
      RealmObjectBase.set(this, 'lastPosition', value);

  @override
  Stream<RealmObjectChanges<ChannelLastScrollPosition>> get changes =>
      RealmObjectBase.getChanges<ChannelLastScrollPosition>(this);

  @override
  ChannelLastScrollPosition freeze() =>
      RealmObjectBase.freezeObject<ChannelLastScrollPosition>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ChannelLastScrollPosition._);
    return const SchemaObject(ObjectType.realmObject, ChannelLastScrollPosition,
        'ChannelLastScrollPosition', [
      SchemaProperty('channelId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('lastPosition', RealmPropertyType.double),
    ]);
  }
}
