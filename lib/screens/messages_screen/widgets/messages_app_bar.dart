import 'package:flutter/material.dart';

import '../../../common/models/chat_model.dart';

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Chat chat;

  const MessagesAppBar({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).scaffoldBackgroundColor,

      ),

      child: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: chat.contact.profileImageUrl.isEmpty
                          ? const AssetImage('assets/images/anonymous.png')
                          : NetworkImage(chat.contact.profileImageUrl) as ImageProvider,
                      radius: 20,
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 6,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: chat.contact.isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.contact.username,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      chat.contact.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(fontSize: 12, color: chat.contact.isOnline ? Colors.green : Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.videocam_outlined,color: Theme.of(context).colorScheme.onPrimaryContainer,),
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => ZegoUIKitPrebuiltCall(
                    //     appID: 1833720256,
                    //     appSign: "3ff3882a27c8e9362af6eaab90f28260d951df8c8c4e382b828303273ae82847",
                    //     userID: 'user1',
                    //     userName: 'User 1',
                    //     callID: 'call_001',
                    //     config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
                    //   ),
                    // ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.phone_outlined,color: Theme.of(context).colorScheme.onPrimaryContainer,),
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => ZegoUIKitPrebuiltCall(
                    //     appID: 1833720256,
                    //     appSign: "3ff3882a27c8e9362af6eaab90f28260d951df8c8c4e382b828303273ae82847",
                    //     userID: 'user1',
                    //     userName: 'User 1',
                    //     callID: 'call_001',
                    //     config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
                    //   ),
                    // ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(80);
}
