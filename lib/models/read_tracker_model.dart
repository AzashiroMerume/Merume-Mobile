class ReadTracker {
  final String channelId;
  final int unreadCount;

  ReadTracker({
    required this.channelId,
    required this.unreadCount,
  });

  factory ReadTracker.fromJson(Map<String, dynamic> json) {
    return ReadTracker(
        channelId: json['channel_id'], unreadCount: json['unread_count']);
  }
}
