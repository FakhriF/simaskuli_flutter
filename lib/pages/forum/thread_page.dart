import 'package:flutter/material.dart';
import 'package:simaskuli/models/forum.dart';
import 'package:intl/intl.dart';

class ThreadPage extends StatelessWidget {
  final Thread thread;

  const ThreadPage({Key? key, required this.thread}) : super(key: key);

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(thread.user.profileUrl),
              ),
              title: Text(thread.user.name),
              subtitle: Text(${formatDate(thread.createdAt)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(thread.content),
            ),
            // Add more widgets for displaying comments, likes, etc.
          ],
        ),
      ),
    );
  }
}