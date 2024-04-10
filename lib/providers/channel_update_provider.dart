import 'package:flutter/foundation.dart';

class ChannelUpdateProvider with ChangeNotifier {
  Map<String, int> _channelUpdates = {};

  Map<String, int> get channelUpdates => _channelUpdates;

  void updateChannelUpdates(Map<String, int> updates) {
    _channelUpdates = updates;
    notifyListeners();
  }
}
