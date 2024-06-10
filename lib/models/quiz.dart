class Quiz {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
    );
  }
}
