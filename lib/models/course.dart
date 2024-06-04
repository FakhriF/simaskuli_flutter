class Course {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String? createdAt;
  final String? updatedAt;
  final String learningOutcomes;
  final int userId;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
    required this.learningOutcomes,
    required this.userId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      learningOutcomes: json['learning_outcomes'],
      userId: json['user_id'],
    );
  }
}