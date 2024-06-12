class Grade {
  final int id;
  final int studentId;
  final int quizId;
  final int courseId;
  final double grade;
  final String quizTitle;
  final String courseTitle;

  Grade({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.courseId,
    required this.grade,
    required this.quizTitle,
    required this.courseTitle,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      studentId: json['student_id'],
      quizId: json['quiz_id'],
      courseId: json['course_id'],
      grade: json['grade'].toDouble(),
      quizTitle: json['quiz_title'],
      courseTitle: json['course_title'],
    );
  }
}
