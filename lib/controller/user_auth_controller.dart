import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simaskuli/controller/token_controller.dart';
import 'package:simaskuli/models/user.dart';

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
