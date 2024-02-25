import 'dart:async';
import 'package:merume_mobile/api/user_api/user_channels_api/followed_channels_api.dart/followed_channels_api.dart';
import 'package:merume_mobile/models/channel_model.dart';

class FollowingChannelsController {
  late StreamController<List<Channel>> _channelStreamController;

  Stream<List<Channel>> get channelStream => _channelStreamController.stream;

  void initController() {
    _channelStreamController = StreamController<List<Channel>>.broadcast();

    fetchFollowingsForController();
  }

  void fetchFollowingsForController() {
    try {
      final Stream<List<Channel>> followingsStream = fetchFollowings();

      followingsStream.listen(
        (List<Channel> channels) {
          if (!_channelStreamController.isClosed) {
            _channelStreamController.add(channels);
          }
        },
        onError: (error) {
          if (!_channelStreamController.isClosed) {
            _channelStreamController.addError(error);
          }
        },
        cancelOnError: true,
      );
    } catch (error) {
      if (!_channelStreamController.isClosed) {
        _channelStreamController.addError(error);
      }
    }
  }

  void dispose() {
    _channelStreamController.close();
  }
}
