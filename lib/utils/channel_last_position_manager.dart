import 'package:shared_preferences/shared_preferences.dart';

class ChannelLastPositionManager {
  static const String _prefix = 'channel_position_';

  static Future<void> savePosition(String channelId, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_prefix$channelId', position);
  }

  static Future<double?> getPosition(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$_prefix$channelId');
  }
}
