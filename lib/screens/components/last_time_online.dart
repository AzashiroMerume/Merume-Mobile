import 'package:intl/intl.dart';

String formatLastSeen(DateTime? lastTimeOnline) {
  if (lastTimeOnline == null) {
    return 'Last seen unknown';
  }
  final timeSinceLastOnline = DateTime.now().difference(lastTimeOnline);
  if (timeSinceLastOnline.inSeconds < 60) {
    return 'Online';
  } else if (timeSinceLastOnline.inMinutes < 60) {
    return 'Last seen ${timeSinceLastOnline.inMinutes} minutes ago';
  } else if (timeSinceLastOnline.inHours < 24) {
    return 'Last seen ${timeSinceLastOnline.inHours} hours ago';
  } else {
    return 'Last seen on ${DateFormat('dd/MM/yyyy').format(lastTimeOnline)}';
  }
}
