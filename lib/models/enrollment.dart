class Enrollment {
  final int userId;
  final int courseId;

  Enrollment({
    required this.userId,
    required this.courseId,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      userId: json['user_id'],
      courseId: json['course_id'],
    );
  }
}
