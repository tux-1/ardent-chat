import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define the state provider to manage dark mode
final themeProvider = StateProvider<bool?>((ref) {
  // Open or access the Hive box
  var box = Hive.box('settings');

  // Check if the 'isDarkMode' key exists in the box
  if (box.containsKey('isDarkMode')) {
    return box.get('isDarkMode');
  } else {
    // Return null to indicate that the value is not set yet
    return null;
  }
});