import 'package:flutter/material.dart';
import 'package:simaskuli/models/questions.dart';
import 'package:simaskuli/controller/questions_controller.dart';

class QuizQuestionsPage extends StatefulWidget {
  final int quizId;
  const QuizQuestionsPage({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizQuestionsPageState createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  late Future<List<Questions>> _questionsFuture;
  final QuestionsController _questionsController = QuestionsController();
  Map<int, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<Questions>> _fetchQuestions() async {
    return await _questionsController.getQuestionsByQuizId(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Questions'),
      ),
      body: FutureBuilder<List<Questions>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question.question_text,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RadioListTile<String>(
                        title: Text(question.option1),
                        value: question.option1,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option2),
                        value: question.option2,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option3),
                        value: question.option3,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option4),
                        value: question.option4,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
