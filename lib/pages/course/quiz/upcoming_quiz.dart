import 'package:flutter/material.dart';
import 'package:simaskuli/models/quiz.dart';
import 'package:simaskuli/pages/course/quiz/question_page.dart'; // Import the new page

class UpcomingQuiz extends StatelessWidget {
  final List<Quiz> quizzes;
  final void Function(int quizId) onQuizSelected;

  UpcomingQuiz({required this.quizzes, required this.onQuizSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(quiz.title),
            subtitle: Text('Due Date: ${quiz.dueDate}'),
            onTap: () => onQuizSelected(quiz.id),
          ),
        );
      },
    );
  }
}
