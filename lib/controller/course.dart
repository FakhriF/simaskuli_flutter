import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseController {
  final String apiUrl = "http://yourapi.com/courses";

  // Fetch all courses
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  // Fetch a single course by ID
  Future<Course> getCourseById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load course');
    }
  }

  // Create a new course
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': course.title,
        'description': course.description,
        'image_url': course.imageUrl,
        'learning_outcomes': course.learningOutcomes,
        'user_id': course.userId,
      }),
    );

    if (response.statusCode == 201) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create course');
    }
  }

  // Update an existing course
  Future<Course> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': course.title,
        'description': course.description,
        'image_url': course.imageUrl,
        'learning_outcomes': course.learningOutcomes,
        'user_id': course.userId,
      }),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update course');
    }
  }

  // Delete a course
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }
}
