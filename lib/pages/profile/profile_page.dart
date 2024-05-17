// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:simaskuli/pages/intro/login_page.dart';
import 'package:simaskuli/pages/profile/edit_profile_page.dart';
import 'package:simaskuli/pages/profile/settings/setting_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 228, 233, 238),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                          "https://cdn.picrew.me/shareImg/org/202404/1904634_70voI7cp.png"),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "User Name",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Role",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // ListTile(
                    //   leading: Icon(Icons.camera_rounded),
                    //   title: Text("Change Profile Picture"),
                    // ),
                    ListTile(
                      leading: const Icon(Icons.edit_rounded),
                      title: const Text("Edit Profile"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfilePage())),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_rounded),
                      title: const Text("Settings"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage())),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: Colors.red),
                      title: const Text(
                        "Log Out",
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage())),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
