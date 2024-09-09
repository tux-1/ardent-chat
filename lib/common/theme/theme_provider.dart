
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';


// Define the provider with Hive check and default to MediaQuery brightness
final themeProvider = Provider<bool?>((ref) {
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