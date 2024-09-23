
import 'package:flutter/material.dart';

class ChatsAppBar extends StatelessWidget {
  const ChatsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextField(
                  showCursor: false,
                  decoration: InputDecoration(
                    hintText: 'Search message...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    prefixIcon: Icon(Icons.search, color:Theme.of(context).colorScheme.onSurface),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.edit_square, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
