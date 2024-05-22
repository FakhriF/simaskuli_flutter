import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simaskuli/controller/token_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/home_page.dart';

Future<User> loadUserData() async {
  const endpoint = 'https://simaskuli-api.vercel.app/api/api/user';
  final token = await getToken();

  final res = await http.get(
    Uri.parse(endpoint),
    // authorization: prefs.getString('access_token'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (res.statusCode == 200) {
    final responseData = json.decode(res.body);
    final user = User.fromJson(responseData);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userId', user.id);
    await prefs.setString('userName', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('profile_url', user.profileUrl);
    await prefs.setString('role', user.role);

    return user;
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<void> registerUser(String name, String email, String password,
    String role, String birthDate, BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Register..."),
              ],
            ),
          ));

  const endpoint = 'https://simaskuli-api.vercel.app/api/api/register';
  final res = await http.post(Uri.parse(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'birthDate': birthDate
      }));

  Navigator.of(context).pop();

  if (res.statusCode == 201) {
    await loadUserData();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  } else if (res.statusCode == 500) {
    final responseData = json.decode(res.body);
    final errorMessage = responseData['message'];

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(errorMessage),
            ));
  } else {
    print(res.statusCode);
    print(res.body);

    // throw Exception('Failed to create user');
  }
}

Future<bool> logout() async {
  const endpoint = 'https://simaskuli-api.vercel.app/api/api/logout';
  final token = await getToken();
  final res = await http.delete(
    Uri.parse(endpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (res.statusCode == 200) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('email');
    await prefs.remove('profile_url');
    await prefs.remove('role');
    await prefs.remove('access_token');

    return true;
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<bool> changePasswordController(
    String oldPass, String newPass, BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Changing Password..."),
              ],
            ),
          ));

  const endpoint = 'https://simaskuli-api.vercel.app/api/api/user/password';
  final token = await getToken();
  final res = await http.put(
    Uri.parse(endpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'oldPassword': oldPass,
      'newPassword': newPass,
    }),
  );

  Navigator.of(context).pop();
  if (res.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text("Password changed successfully"),
    ));
    return true;
  } else if (res.statusCode == 401) {
    final response = json.decode(res.body);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(response['message']),
    ));
    return false;
  } else {
    throw Exception('Failed to load user data');
  }
}
