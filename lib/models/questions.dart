class Questions {
  final int id;
  final String question_text;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String correct_answer;
  final int quizId;

  Questions({
    required this.id,
    required this.question_text,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correct_answer,
    required this.quizId,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      id: json['id'],
      question_text: json['question_text'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      correct_answer: json['correct_answer'],
      quizId: json['quiz_id'],
    );
  }
}
