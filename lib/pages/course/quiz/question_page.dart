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
        title: const Text('Quiz Questions'),
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
                      Text('1. ${question.option1}'),
                      Text('2. ${question.option2}'),
                      Text('3. ${question.option3}'),
                      Text('4. ${question.option4}'),
                      // Optionally, you can display the correct answer
                      // Text('Correct answer: ${question.correct_answer}', style: TextStyle(color: Colors.green)),
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
