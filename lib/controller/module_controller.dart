import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/module.dart';

class ModuleController {
  String baseUrl = "https://simaskuli-api.vercel.app/api/api/course/";

  // Fetch a single course by ID
  Future<Course> getCourseById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$id'));

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

  // Fetch modules by course ID
  Future<List<Module>> getModule(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$id/module"));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map<Module>((module) => Module.fromJson(module))
            .toList();
      } else {
        print('Failed to load modules: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load modules');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load modules');
    }
  }

  // Create a new module
  Future<Module> createModule(Module module) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${module.courseId}/module'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': module.title,
          'learning_achievements': module.learningAchievements,
          'learning_materials': module.learningMaterials,
          'title_youtube': module.titleYoutube,
          'description_youtube': module.descriptionYoutube,
          'additional_material_title': module.additionalMaterialTitle,
          'additional_material_description':
              module.additionalMaterialDescription,
          'description': module.description,
          'video_link': module.videoLink,
          'note_link': module.noteLink,
        }),
      );

      if (response.statusCode == 201) {
        return Module.fromJson(json.decode(response.body));
      } else {
        print('Failed to create module: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create module');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to create module');
    }
  }

  // Update an existing module
  Future<Module> updateModule(Module module) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl${module.courseId}/module/${module.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': module.title,
          'learning_achievements': module.learningAchievements,
          'learning_materials': module.learningMaterials,
          'title_youtube': module.titleYoutube,
          'description_youtube': module.descriptionYoutube,
          'additional_material_title': module.additionalMaterialTitle,
          'additional_material_description':
              module.additionalMaterialDescription,
          'description': module.description,
          'video_link': module.videoLink,
          'note_link': module.noteLink,
        }),
      );

      if (response.statusCode == 200) {
        return Module.fromJson(json.decode(response.body));
      } else {
        print('Failed to update module: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update module');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to update module');
    }
  }

  // Delete a module
  Future<void> deleteModule(int courseId, int moduleId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$courseId/module/$moduleId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to delete module: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete module');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to delete module');
    }
  }
}
