import 'package:flutter/material.dart';
import 'package:simaskuli/controller/user_auth_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword(BuildContext context) async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: const Text('Please Fill All Fields'),
      ));
    } else {
      if (oldPasswordController.text == newPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Text('New Password cannot be same as old password'),
        ));
        return;
      } else if (newPasswordController.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Text('Password must be at least 8 characters'),
        ));
        return;
      }

      final success = await changePasswordController(
          oldPasswordController.text, newPasswordController.text, context);
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  bool visibleOldPass = true;
  bool visibleNewPass = true;

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
                  'Change Your\nPassword',
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
                  controller: oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Your Old Password',
                    hintText: 'Enter your old password',
                    prefixIcon:
                        const Icon(Icons.password_outlined, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: visibleOldPass
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {
                        setState(() {
                          visibleOldPass = !visibleOldPass;
                        });
                      },
                    ),
                  ),
                  obscureText: visibleOldPass,
                  obscuringCharacter: '•',
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Your New Password',
                    hintText: 'Enter your new password',
                    prefixIcon:
                        const Icon(Icons.password_outlined, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: visibleNewPass
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {
                        setState(() {
                          visibleNewPass = !visibleNewPass;
                        });
                      },
                    ),
                  ),
                  obscureText: visibleNewPass,
                  obscuringCharacter: '•',
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        changePassword(context);
                      },
                      child: const Text('Change Password'),
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
