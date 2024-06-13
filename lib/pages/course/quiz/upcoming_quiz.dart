import 'package:flutter/material.dart';
import 'package:simaskuli/models/quiz.dart';
//import 'package:simaskuli/pages/course/quiz/question_page.dart'; // Import the new page

class UpcomingQuiz extends StatelessWidget {
  final List<Quiz> quizzes;
  final void Function(int quizId) onQuizSelected;
  final void Function(int quizId) onEditQuiz;
  final void Function(int quizId) onDeleteQuiz;
  final void Function(int quizId) onAddQuestion;

  UpcomingQuiz({
    required this.quizzes,
    required this.onQuizSelected,
    required this.onEditQuiz,
    required this.onDeleteQuiz,
    required this.onAddQuestion,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              width: 300, // Adjust the width as needed
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Due Date: ${quiz.dueDate}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => onAddQuestion(quiz.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => onEditQuiz(quiz.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => onDeleteQuiz(quiz.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
