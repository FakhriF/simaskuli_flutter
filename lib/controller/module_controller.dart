import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/module.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/controller/course_controller.dart';

class ModuleController {
  String baseUrl = "https://simaskuli-api.vercel.app/api/api/course/";
  final String userApiUrl = "https://simaskuli-api.vercel.app/api/api/users";
  final String courseApiUrl = "https://simaskuli-api.vercel.app/api/api/course";

  // Fetch a single course by ID
  Future<Course> getCourseById(int id) async {
    try {
      final response = await http.get(Uri.parse('$courseApiUrl/$id'));

      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      } else {
        print('Failed to load course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load course');
    }
  }

  Future<List<Module>> getModule(String id) async {
    try {
      final response = await http.get(Uri.parse(
          "https://simaskuli-api.vercel.app/api/api/course/$id/module"));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map<Module>((module) => Module.fromJson(module))
            .toList();
      } else {
        print('Failed to load courses: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load modules');
    }
  }
}
