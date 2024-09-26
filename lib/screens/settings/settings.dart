import 'package:ardent_chat/screens/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/helpers/auth_helper.dart';
import '../../common/widgets/theme_switch.dart';

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
            const SizedBox(height: 150),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AuthHelper.signOut(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Logout'),
                ),
              ),
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
