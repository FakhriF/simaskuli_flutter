class Grade {
  final String subject;
  final int score;
  final int quiz;

  const Grade({
    required this.quiz,
    required this.subject,
    required this.score, 
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      quiz: json['quiz_id'],
      subject: json['subject'],
      score: json['score'],
    );
  }
}
