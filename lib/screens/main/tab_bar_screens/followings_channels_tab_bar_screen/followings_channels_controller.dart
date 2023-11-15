import 'dart:async';
import 'package:merume_mobile/api/user_channels_api/followed_channels_api.dart/followed_channels_api.dart';
import 'package:merume_mobile/models/channel_model.dart';

class FollowingChannelsController {
  final StreamController<List<Channel>> _channelStreamController =
      StreamController<List<Channel>>.broadcast();

  Stream<List<Channel>> get channelStream => _channelStreamController.stream;

  void fetchFollowingsForController() {
    try {
      // Assuming fetchFollowings returns a Stream<List<Channel>>
      final Stream<List<Channel>> followingsStream = fetchFollowings();

      // Pipe events from followingsStream to _channelStreamController
      followingsStream.listen(
        (List<Channel> channels) {
          _channelStreamController.add(channels);
        },
        onError: (error) {
          // Handle error
          print('Error fetching followings: $error');
        },
      );
    } catch (error) {
      // Handle error if fetchFollowings() is not returning a Stream
      print('Error fetching followings: $error');
    }
  }

  void dispose() {
    _channelStreamController.close();
  }
}
