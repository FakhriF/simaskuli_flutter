import 'package:flutter/material.dart';


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
                      radius: 80,
                    ),
                    SizedBox(height: 24),
                    Text(
                      "User Name",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_rounded),
                      title: Text("Change Profile Picture"),
                    ),
                    ListTile(
                      leading: Icon(Icons.edit_rounded),
                      title: Text("Edit Profile"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings_rounded),
                      title: Text("Settings"),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded, color: Colors.red),
                      title: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red),
                      ),
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
