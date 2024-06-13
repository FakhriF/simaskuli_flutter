import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/module.dart';

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

  Future<Module> createCourse(Module module) async {
    try {
      final response = await http.post(
        Uri.parse('$courseApiUrl/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': module.id,
          'courseId': module.courseId,
          'title': module.title,
          'learningAchievements': module.learningAchievements,
          'learningMaterials': module.learningMaterials,
          'titleYoutube': module.titleYoutube,
          'descriptionYoutube': module.descriptionYoutube,
          'additionalMaterialTitle': module.additionalMaterialTitle,
          'additionalMaterialDescription': module.additionalMaterialDescription,
          'description': module.description,
          'videoLink': module.videoLink,
          'noteLink': module.noteLink,
        }),
      );

      if (response.statusCode == 201) {
        return Module.fromJson(json.decode(response.body));
      } else {
        print('Failed to create course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to create course');
    }
  }

  // Update an existing course
  Future<Module> updateModule(Module module) async {
    try {
      final response = await http.put(
        Uri.parse('$courseApiUrl/${module}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': module.id,
          'courseId': module.courseId,
          'title': module.title,
          'learningAchievements': module.learningAchievements,
          'learningMaterials': module.learningMaterials,
          'titleYoutube': module.titleYoutube,
          'descriptionYoutube': module.descriptionYoutube,
          'additionalMaterialTitle': module.additionalMaterialTitle,
          'additionalMaterialDescription': module.additionalMaterialDescription,
          'description': module.description,
          'videoLink': module.videoLink,
          'noteLink': module.noteLink,
        }),
      );

      if (response.statusCode == 200) {
        return Module.fromJson(json.decode(response.body));
      } else {
        print('Failed to update course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to update course');
    }
  }

  // Delete a course
  Future<void> deleteModule(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$courseApiUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to delete course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to delete course');
    }
  }
}
