import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/grade.dart';

class GradesController {
  final String courseApiUrl = 'https://simaskuli-api.vercel.app/api/api/course';
  final String userApiUrl = 'https://simaskuli-api.vercel.app/api/api/users';

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

  Future<List<Grade>> getQuizData(int courseId, int userId) async {
    try {
      final response = await http.get(Uri.parse('$courseApiUrl/$courseId/grades/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Grade.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      throw Exception('Failed to load quiz data: $e');
    }
  }
}
