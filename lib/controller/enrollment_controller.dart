import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/enrollment.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/user.dart';
import 'course_controller.dart';

class EnrollmentController {
  final String enrollmentApiUrl = "https://simaskuli-api.vercel.app/api/api/enrollment";
  final String userApiUrl = "https://simaskuli-api.vercel.app/api/api/users";
  final CourseController _courseController = CourseController();

  // Fetch all enrollments
  Future<List<Enrollment>> index() async {
    try {
      final response = await http.get(Uri.parse(enrollmentApiUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map<Enrollment>((enrollment) => Enrollment.fromJson(enrollment)).toList();
      } else {
        print('Failed to load enrollments: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load enrollments');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load enrollments');
    }
  }

  // Enroll in a course
  Future<void> store(int userId, int courseId) async {
    try {
      final response = await http.post(
        Uri.parse(enrollmentApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'user_id': userId, 'course_id': courseId}),
      );

      if (response.statusCode != 201) {
        print('Failed to enroll in course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to enroll in course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to enroll in course');
    }
  }

  // Get enrollments by user ID
  Future<List<Course>> getByUserId(int userId) async {
    try {
      final response = await http.get(Uri.parse('$enrollmentApiUrl/user/$userId'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Course> courses = [];

        for (var enrollment in jsonResponse) {
          int courseId = enrollment['course_id'];
          Course course = await _courseController.getCourseById(courseId);
          courses.add(course);
        }

        return courses;
      } else {
        print('Failed to load enrollments: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load enrollments');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load enrollments');
    }
  }

  // Get enrollments by course ID
  Future<List<User>> getByCourseId(int courseId) async {
    try {
      final response = await http.get(Uri.parse('$enrollmentApiUrl/course/$courseId'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<User> users = [];

        for (var enrollment in jsonResponse) {
          int userId = enrollment['user_id'];
          User user = await getUserById(userId);
          users.add(user);
        }

        return users;
      } else {
        print('Failed to load enrollments: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load enrollments');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load enrollments');
    }
  }

  // Unenroll from a course
  Future<void> destroy(int userId, int courseId) async {
    try {
      final response = await http.delete(
        Uri.parse(enrollmentApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'user_id': userId, 'course_id': courseId}),
      );

      if (response.statusCode != 200) {
        print('Failed to unenroll from course: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to unenroll from course');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to unenroll from course');
    }
  }

  // Get user details by ID
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

  // Check if user is enrolled in course
  Future<bool> isEnrolled(int userId, int courseId) async {
    try {
      final response = await http.get(Uri.parse('$enrollmentApiUrl/course/$courseId'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.any((enrollment) => enrollment['user_id'] == userId);
      } else {
        print('Failed to check enrollment: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to check enrollment');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to check enrollment');
    }
  }

}
