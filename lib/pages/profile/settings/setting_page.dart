import 'package:flutter/material.dart';
import 'package:simaskuli/pages/profile/settings/change_password_page.dart';
import 'package:simaskuli/pages/profile/settings/connected_devices_page.dart';
import 'package:simaskuli/pages/profile/settings/delete_account_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.password_rounded),
            title: const Text("Change Password"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.device_hub_rounded),
            title: const Text("Connected Devices"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ConnectedDevicesPage()),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DeleteAccountPage()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.info_outline_rounded,
            ),
            title: const Text(
              "About App",
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text("About Simaskuli App"),
                content: Text(
                  "This is Simaskuli version 1.0.0\n\n©2024 Simaskuli Team, All rights reserved.",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
