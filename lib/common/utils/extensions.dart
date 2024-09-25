import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    DateTime now = DateTime.now();

    // Start of today and yesterday for comparison
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    // Compare the messageDate with today and yesterday
    if (isAfter(startOfToday)) {
      // Message is from today
      return DateFormat.jm().format(this); // e.g., "2:00 PM"
    } else if (isAfter(startOfYesterday)) {
      // Message is from yesterday
      return 'Yesterday';
    } else if (isAfter(startOfToday.subtract(const Duration(days: 7)))) {
      // Message is within the last 7 days
      return DateFormat.EEEE().format(this); // e.g., "Monday"
    } else {
      // Message is older, show full date
      return DateFormat.yMMMd().format(this); // e.g., "Sep 23, 2024"
    }
  }
}
