import 'package:flutter/material.dart';

import '../../common/helpers/friends_helper.dart';
import '../../common/models/contact.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Contact> _searchResults = [];
  Map<String, bool> friendRequestStatus = {};

  final FriendsHelper _friendsHelper =
      FriendsHelper(); // Instantiate FriendsHelper

  // Search friends using Firebase Firestore
  Future<void> _searchFriends(String query) async {
    setState(() {
      _isSearching = true;
    });

    // Call the searchByUsername method to get users from Firebase
    final results = await _friendsHelper.searchByUsername(query);

    setState(() {
      _isSearching = false;
      _searchResults = results;

      // Initialize friend request status for each result
      for (var contact in _searchResults) {
        friendRequestStatus[contact.id] =
            false; // All requests are unsent initially
      }
    });
  }

  // Check if the user is already friends
  Future<bool> _checkIfAlreadyFriends(String friendId) async {
    return await _friendsHelper.isAlreadyFriends(friendId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Friend',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6e3cfd),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search For Friends',
                hintText: 'Enter username',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6e3cfd)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6e3cfd)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF6e3cfd)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  _searchFriends(query);
                }
              },
            ),
            const SizedBox(height: 10),
            if (_isSearching)
              const CircularProgressIndicator(color: Colors.grey)
            else if (_searchResults.isEmpty)
              Column(
                children: [
                  Image.asset(
                    'assets/images/addFriend2.png',
                    height: 285,
                    width: 300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Search for friends to add',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final contact = _searchResults[index];
                    final isSent = friendRequestStatus[contact.id] ?? false;

                    return FutureBuilder<bool>(
                      future: _checkIfAlreadyFriends(contact.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text(contact.username),
                            trailing: CircularProgressIndicator(),
                          );
                        }

                        final isAlreadyFriends = snapshot.data ?? false;

                        return ListTile(
                          title: Text(contact.username),
                          trailing: ElevatedButton(
                            onPressed: isAlreadyFriends || isSent
                                ? null // Disable button if already friends or request sent
                                : () async {
                                    // Call addFriend method to add the friend
                                    await _friendsHelper.addFriend(contact.id);

                                    setState(() {
                                      friendRequestStatus[contact.id] =
                                          true; // Mark request as sent
                                    });

                                    // Show a confirmation message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Friend request sent to ${contact.username}'),
                                        backgroundColor:
                                            const Color(0xFF6e3cfd),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSent
                                  ? Colors.grey
                                  : const Color(0xFF6e3cfd),
                            ),
                            child: Text(
                              isAlreadyFriends
                                  ? 'Already Friends'
                                  : isSent
                                      ? 'Request Sent'
                                      : 'Send',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
