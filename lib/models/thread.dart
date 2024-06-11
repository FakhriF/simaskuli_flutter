import 'package:simaskuli/models/forum.dart';
import 'package:simaskuli/models/user.dart';

class ThreadPost {
  final int id;
  final int threadId;
  final int userId;
  String content;
  final bool like;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic> threadData;
  final Map<String, dynamic> userData;

  ThreadPost({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.content,
    required this.like,
    required this.createdAt,
    required this.updatedAt,
    required this.threadData,
    required this.userData,
  });

  factory ThreadPost.fromJson(Map<String, dynamic> json) {
    return ThreadPost(
      id: json['id'],
      threadId: json['thread_id'],
      userId: json['user_id'],
      content: json['content'],
      like: json['like'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      threadData: json['thread'],
      userData: json['user'],
    );
  }

  Thread get thread => Thread.fromJson(threadData);
  User get user => User.fromJson(userData);
}