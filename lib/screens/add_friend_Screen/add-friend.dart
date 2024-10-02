import 'package:flutter/material.dart';

import '../../common/widgets/theme_switch.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _searchResults = [];
  Map<String, bool> friendRequestStatus =
      {}; //  sent/unsent state for each friend

  //  friend search ( API call in  app)
  void _searchFriends(String query) {
    setState(() {
      _isSearching = true;
    });

    //  network request delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSearching = false;
        _searchResults = List<String>.generate(
          1,
          (index) => 'Friend $query', //  search result
        );

        //  friend request status for each result
        for (var friend in _searchResults) {
          friendRequestStatus[friend] = false; //  all requests are unsent
        }
      });
    });
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
            //background color of screen

            color: Theme.of(context).brightness == Brightness.dark

                //dark mode
                ? Theme.of(context).colorScheme.secondary

                //light mode
                : Theme.of(context).colorScheme.surfaceContainerLow),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // delete it after check the dark mode
            ThemeSwitch(),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search For Friends',
                hintText: 'Enter username or email',
                labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark

                        //dark mode
                        ? Theme.of(context).colorScheme.onPrimaryContainer

                        //light mode
                        : Theme.of(context).colorScheme.onSecondary),
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSecondary,
                ),
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
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    // Use onPrimaryContainer color in dark mode
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    // Use secondary color in light mode
                    : Theme.of(context).colorScheme.onSecondary,
              ),
              textInputAction: TextInputAction.search,
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
                  Text(
                    'Search for friends to add',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          // Use onPrimaryContainer color in dark mode
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          // Use secondary color in light mode
                          : Theme.of(context).colorScheme.onSecondary,
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
                    final friend = _searchResults[index];
                    final isSent = friendRequestStatus[friend] ?? false;

                    return ListTile(
                      title: Text(
                        friend,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              // Use onPrimaryContainer color in dark mode
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              // Use secondary color in light mode
                              : Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            friendRequestStatus[friend] = !isSent;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isSent
                                    ? 'Friend request removed for $friend'
                                    : 'Friend request sent to $friend',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: friendRequestStatus[friend]!
                                  ? const Color(0xFF6e3cfd)
                                  : Colors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6e3cfd),
                        ),
                        child: Text(
                          isSent ? 'Unsend' : 'Send',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
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
