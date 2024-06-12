import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:simaskuli/controller/user_auth_controller.dart";
import "package:simaskuli/models/user.dart";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({required this.userData, super.key});

  final User userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController profileUrlController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.userData.name;
    profileUrlController.text = widget.userData.profileUrl;
    birthController.text = widget.userData.birthDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const Text(
                  'Edit Your\nProfile',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 5,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon:
                        const Icon(Icons.person_rounded, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: profileUrlController,
                  decoration: InputDecoration(
                    labelText: 'Profile Picture Link',
                    prefixIcon:
                        const Icon(Icons.camera_rounded, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: birthController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                    hintText: 'YYYY-MM-DD',
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () async {
                        final datePick = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (datePick != null) {
                          final formatter =
                              DateFormat('yyyy-MM-dd').format(datePick);
                          birthController.text = formatter.toString();
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        nameController.text = widget.userData.name;
                        profileUrlController.text = widget.userData.profileUrl;
                      },
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                      ),
                      onPressed: () {
                        editUserProfile(
                            nameController.text,
                            profileUrlController.text,
                            birthController.text,
                            context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
