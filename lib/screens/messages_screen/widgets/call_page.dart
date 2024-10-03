import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ZEGOCLOUD UIKit for Calls
    return ZegoUIKitPrebuiltCall(
      appID: 1833720256, // Replace with your ZEGOCLOUD AppID
      appSign: "3ff3882a27c8e9362af6eaab90f28260d951df8c8c4e382b828303273ae82847", // Replace with your ZEGOCLOUD AppSign
      userID: 'user1', // The unique ID for the local user
      userName: 'User 1', // The name for the local user
      callID: 'call_001', // A unique call ID for every call
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(), // Choose between voice, video, or group calls
    );
  }
}