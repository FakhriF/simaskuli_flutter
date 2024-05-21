// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:simaskuli/controller/user_auth_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/intro/login_page.dart';
import 'package:simaskuli/pages/profile/edit_profile_page.dart';
import 'package:simaskuli/pages/profile/settings/setting_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userData, super.key});

  final User userData;

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
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(userData.profileUrl),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      userData.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userData.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
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
                          builder: (context) => EditProfilePage(
                            userData: userData,
                          ),
                        ),
                      ),
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
                      leading:
                          const Icon(Icons.logout_rounded, color: Colors.red),
                      title: const Text(
                        "Log Out",
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Log Out"),
                            content: const Text(
                              "Are you sure you want to log out?",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 16),
                                                Text("Logging Out..."),
                                              ],
                                            ),
                                          ));

                                  final logOut = await logout();

                                  if (logOut) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
