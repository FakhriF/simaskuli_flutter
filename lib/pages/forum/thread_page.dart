import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simaskuli/models/forum.dart';
import 'package:simaskuli/models/thread.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ThreadPage extends StatefulWidget {
  final Thread thread;

  const ThreadPage({Key? key, required this.thread}) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  Future<List<ThreadPost>> fetchReplies() async {
    debugPrint('Fetching replies for thread ID: ${widget.thread.id}');
    final response = await http.get(Uri.parse('https://simaskuli-api.vercel.app/api/api/forum/${widget.thread.id}/posts'));
    debugPrint('API response status code: ${response.statusCode}');
    debugPrint('API response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        List<ThreadPost> threadPosts = (json.decode(response.body) as List)
            .map((data) => ThreadPost.fromJson(data))
            .toList();
        return threadPosts;
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
        throw Exception('Failed to parse replies');
      }
    } else {
      throw Exception('Failed to load replies. Status code: ${response.statusCode}');
    }
  }


  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original post
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.thread.user.profileUrl),
              ),
              title: Text(widget.thread.user.name),
              subtitle: Text(formatDate(widget.thread.createdAt)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.thread.content),
            ),
            // Replies
            FutureBuilder<List<ThreadPost>>(
              future: fetchReplies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load replies: ${snapshot.error}'));
                } else {
                  final replies = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final reply = replies[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(reply.user.profileUrl),
                        ),
                        title: Text(reply.user.name),
                        subtitle: Text(reply.content),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}