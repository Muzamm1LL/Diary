import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            title: const Text('Edit Profile'),
            onTap: () {
              // Add navigation or action for editing the profile
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Add navigation or action for changing the password
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () {
              // Add navigation or action for deleting the account
            },
          ),
        ],
      ),
    );
  }
}
