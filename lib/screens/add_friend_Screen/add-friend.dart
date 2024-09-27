import 'package:ardent_chat/screens/chat_screen/chat_screen.dart';

import 'package:flutter/material.dart';
import 'package:ardent_chat/common/widgets/dynamic_form_field.dart';
import 'package:flutter/material.dart';

import '../../common/constants/regex_validation.dart';


import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
 const AddFriendScreen({Key? key}) : super(key: key);

 @override
 _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
 final TextEditingController _searchController = TextEditingController();
 bool _isSearching = false;
 List<String> _searchResults = [];
 Map<String, bool> friendRequestStatus = {}; // Track sent/unsent state for each friend

 // Simulate friend search (this would be an API call in a real app)
 void _searchFriends(String query) {
  setState(() {
   _isSearching = true;
  });

  // Simulate network request delay
  Future.delayed(const Duration(seconds: 2), () {
   setState(() {
    _isSearching = false;
    _searchResults = List<String>.generate(
     1,
         (index) => 'Friend $query', // Example search result
    );

    // Initialize friend request status for each result
    for (var friend in _searchResults) {
     friendRequestStatus[friend] = false; // Initially, all requests are unsent
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
   body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
     children: [
      TextField(
       controller: _searchController,
       decoration: InputDecoration(
        labelText: 'Search For Friends',
        hintText: 'Enter username or email',
        labelStyle: const TextStyle(color: Colors.black38),
        hintStyle: const TextStyle(color: Colors.black38),
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
       style: const TextStyle(color: Colors.black),
       textInputAction: TextInputAction.search,
       onSubmitted: (query) {
        if (query.isNotEmpty) {
         _searchFriends(query);
        }
       },
      ),
      const SizedBox(height: 150),
      if (_isSearching)
       const CircularProgressIndicator(color: Colors.grey)
      else if (_searchResults.isEmpty)
       Column(
        children: [
         Image.asset(
          'assets/images/addFriend2.png', // Replace with your image path
          height: 300,
          width: 300,
         ),
         const SizedBox(height: 15),
         const Text(
          'Search for friends to add',
          style: TextStyle(color: Colors.black),
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
            style: const TextStyle(color: Colors.black),
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

 @override
 void dispose() {
  _searchController.dispose();
  super.dispose();
 }
}











































