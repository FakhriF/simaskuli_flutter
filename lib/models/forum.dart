import 'package:simaskuli/models/user.dart';

class Thread {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;
  final User user;

  Thread({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }
}

class PaginatedThreads {
  final List<Thread> items;
  final Map<String, dynamic> meta;

  PaginatedThreads({
    required this.items,
    required this.meta,
  });
}
