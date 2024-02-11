import 'package:intl/intl.dart';

String formatPostDate(DateTime sentDay) {
  final now = DateTime.now();
  final fullDateFormat = DateFormat("dd MMM yyyy");
  final sentDayFormat = DateFormat("dd MMM");
  if (now.year == sentDay.year &&
      now.month == sentDay.month &&
      now.day == sentDay.day) {
    // Post was sent today
    return 'Today';
  } else {
    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == sentDay.year &&
        yesterday.month == sentDay.month &&
        yesterday.day == sentDay.day) {
      // Post was sent yesterday
      return 'Yesterday';
    } else if (now.year == sentDay.year) {
      // Show the date without the year
      return sentDayFormat.format(sentDay).toString();
    } else {
      // Show the full date with the year
      return fullDateFormat.format(sentDay).toString();
    }
  }
}
