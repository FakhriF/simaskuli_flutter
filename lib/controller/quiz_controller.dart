import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/questions.dart';
import 'package:simaskuli/models/quiz.dart';

class QuizController {
  final String quizApiUrl = "https://simaskuli-api.vercel.app/api/api/quiz";

  // Fetch all quizzes
  Future<List<Quiz>> getQuiz() async {
    try {
      final response = await http.get(Uri.parse(quizApiUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map<Quiz>((quiz) => Quiz.fromJson(quiz)).toList();
      } else {
        print('Failed to load quizzes: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load quizzes');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load quizzes');
    }
  }

  Future<Quiz> createQuiz(Quiz quiz) async {
    try {
      final response = await http.post(
        Uri.parse('$quizApiUrl/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': quiz.title,
          'description': quiz.description,
          'dueDate': quiz.dueDate,
          'course_id': quiz.courseId,
        }),
      );

      if (response.statusCode == 201) {
        return Quiz.fromJson(json.decode(response.body));
      } else {
        print('Failed to create quiz: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create quiz');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to create quiz');
    }
  }

  // Fetch a single quiz by quizID
  Future<Quiz> getQuizById(int id) async {
    try {
      final response = await http.get(Uri.parse('$quizApiUrl/$id'));

      if (response.statusCode == 200) {
        return Quiz.fromJson(json.decode(response.body));
      } else {
        print('Failed to load quiz: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load quiz');
    }
  }

  // Fetch questions by quizID
  Future<List<Questions>> getQuestionsByQuizId(int id) async {
    try {
      final response = await http.get(Uri.parse('$quizApiUrl/$id/questions'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map<Questions>((question) => Questions.fromJson(question))
            .toList();
      } else {
        print('Failed to load questions: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load questions');
    }
  }
}
