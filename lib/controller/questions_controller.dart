import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/questions.dart';

class QuestionsController {
  final String questionsApiUrl =
      "https://simaskuli-api.vercel.app/api/api/questions";
  final String quizApiUrl = "https://simaskuli-api.vercel.app/api/api/quiz";

  // Fetch all questions
  Future<List<Questions>> getQuestions() async {
    try {
      final response = await http.get(Uri.parse(questionsApiUrl));

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

  // Fetch questions by quizId
  Future<List<Questions>> getQuestionsByQuizId(int quizId) async {
    try {
      final response =
          await http.get(Uri.parse('$quizApiUrl/$quizId/questions'));

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

  // Fetch a single question by id
  Future<Questions> getQuestionById(int id) async {
    try {
      final response = await http.get(Uri.parse('$questionsApiUrl/$id'));

      if (response.statusCode == 200) {
        return Questions.fromJson(json.decode(response.body));
      } else {
        print('Failed to load question: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load question');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to load question');
    }
  }

  // Add a new question
  Future<Questions> createQuestion(Questions question) async {
    try {
      final response = await http.post(
        Uri.parse('$questionsApiUrl/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'question_text': question.question_text,
          'option1': question.option1,
          'option2': question.option2,
          'option3': question.option3,
          'option4': question.option4,
          'correct_answer': question.correct_answer,
          'quiz_id': question.quizId,
        }),
      );

      if (response.statusCode == 201) {
        return Questions.fromJson(json.decode(response.body));
      } else {
        print('Failed to create question: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create question');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to create question');
    }
  }

  // Update an existing question
  Future<Questions> editQuestion(Questions question) async {
    try {
      final response = await http.put(
        Uri.parse('$questionsApiUrl/${question.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'question_text': question.question_text,
          'option1': question.option1,
          'option2': question.option2,
          'option3': question.option3,
          'option4': question.option4,
          'correct_answer': question.correct_answer,
          'quiz_id': question.quizId,
        }),
      );

      if (response.statusCode == 200) {
        return Questions.fromJson(json.decode(response.body));
      } else {
        print('Failed to update question: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update question');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to update question');
    }
  }

  // Delete a question
  Future<void> deleteQuestion(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$questionsApiUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to delete question: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete question');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to delete question');
    }
  }
}
