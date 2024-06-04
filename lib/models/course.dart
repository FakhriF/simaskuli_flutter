class Course {
  final int id;
  final String title;
  final String description;
  final String learningOutcomes;
  final String imageUrl;
  final int userId;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.learningOutcomes,
    required this.imageUrl,
    required this.userId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      learningOutcomes: json['learning_outcomes'],
      imageUrl: json['image_url'],
      userId: json['user_id'],
    );
  }
}
