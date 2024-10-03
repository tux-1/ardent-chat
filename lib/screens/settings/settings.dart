import 'package:flutter/material.dart';
import '../../common/helpers/auth_helper.dart';
import '../../common/widgets/theme_switch.dart';
import '../profile_screen/profile_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              title: 'Profile Information',
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ////
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Privacy",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              title: 'Show online Status',
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  ////
                },
              ),
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              title: 'Location Sharing',
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  ////
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Theme",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            const ListTileWidget(
              title: 'Dark Mode',
              trailing: ThemeSwitch(),
            ),
            const Divider(
              height: 30,
              thickness: .5,
            ),
            ListTileWidget(
              title: 'Logout',
              trailing: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 32,
              ),
              onTap: () {
                AuthHelper.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final String title;
  final Widget trailing;
  final void Function()? onTap;

  const ListTileWidget({
    super.key,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
