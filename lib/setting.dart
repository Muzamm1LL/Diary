import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            title: const Text('Enable Notifications'),
            trailing: Switch(
              value: _isNotificationEnabled,
              onChanged: (value) {
                setState(() {
                  _isNotificationEnabled = value;
                  if (value) {
                    Fluttertoast.showToast(
                      msg: 'Notifications enabled',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Account Settings'),
            onTap: () {
              // Add navigation or action for account settings
            },
          ),
          ListTile(
            title: const Text('Privacy Settings'),
            onTap: () {
              // Add navigation or action for privacy settings
            },
          ),
        ],
      ),
    );
  }
}
