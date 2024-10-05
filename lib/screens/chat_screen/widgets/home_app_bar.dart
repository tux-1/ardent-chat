import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chats_cubit.dart';

class ChatsAppBar extends StatefulWidget {
  const ChatsAppBar({super.key});

  @override
  State<ChatsAppBar> createState() => _ChatsAppBarState();
}

class _ChatsAppBarState extends State<ChatsAppBar> {
  final TextEditingController searchController = TextEditingController();
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        _showClearIcon = searchController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  context.read<ChatsCubit>().updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search chat...',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  suffixIcon: _showClearIcon
                      ? IconButton(
                    icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    onPressed: () {
                      searchController.clear();
                      context.read<ChatsCubit>().updateSearchQuery('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onPrimaryContainer),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
