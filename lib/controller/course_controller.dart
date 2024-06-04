import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/user.dart';

class CourseController {
  final String courseApiUrl = "https://simaskuli-api.vercel.app/api/api/course";
  final String userApiUrl = "https://simaskuli-api.vercel.app/api/api/users";

  // Fetch all courses
  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(Uri.parse(courseApiUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map<Course>((course) => Course.fromJson(course)).toList();
      } else {
        print('Failed to load courses: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load courses');
    }
  }

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

  // Fetch user details by ID
  Future<User> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$userApiUrl/$id'));

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        print('Failed to load user: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load user');
    }
  }

  // Create a new course
  Future<Course> createCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$courseApiUrl/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': course.title,
          'description': course.description,
          'learning_outcomes': course.learningOutcomes,
          'image_url': course.imageUrl,
          'user_id': course.userId,
        }),
      );

      if (response.statusCode == 201) {
        return Course.fromJson(json.decode(response.body));
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
  Future<Course> updateCourse(Course course) async {
    try {
      final response = await http.put(
        Uri.parse('$courseApiUrl/${course.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': course.title,
          'description': course.description,
          'learning_outcomes': course.learningOutcomes,
          'image_url': course.imageUrl,
          'user_id': course.userId,
        }),
      );

      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
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
  Future<void> deleteCourse(int id) async {
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
