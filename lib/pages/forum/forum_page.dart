import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/forum.dart';
import 'package:simaskuli/pages/forum/thread_page.dart';


class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key); //TODO PASS USER PARAMETER FROM PREVIOUS PAGE

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int? currentUser;
  late Future<List<Thread>> threads;

  @override
  void initState() {
    super.initState();
    threads = getThread();
    loadCurrentUser();
  }

  Future<List<Thread>> getThread() async {
    const endpoint = 'https://simaskuli-api.vercel.app/api/api/forum';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      List<Thread> threads = (json.decode(response.body)["data"] as List)
          .map((data) => Thread.fromJson(data))
          .toList();
      return threads;
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> createThread(String title, String content, int userId) async {
    const endpoint = 'https://simaskuli-api.vercel.app/api/api/forum';

    final requestBody = json.encode({
      'title': title,
      'content': content,
      'user_id': userId,
    });

    debugPrint('Request Body: $requestBody');

    final response = await http.post(
      Uri.parse(endpoint),
      body: requestBody,
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      debugPrint('Post created successfully');
    } else {
      throw Exception('Failed to create post: ${response.statusCode}');
    }
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
  }

  Future<void> loadCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getInt('userId') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: const Text(
                "Forum",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Thread>>(
                future: threads,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No threads found.'));
                  } else {
                    List<Thread> threads = snapshot.data!;
                    return ListView.builder(
                      itemCount: threads.length,
                      itemBuilder: (context, index) {
                        Thread thread = threads[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ThreadPage(thread: thread),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(thread.user.profileUrl),
                              ),
                              title: Text(
                                thread.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'By ${thread.user.name}, ${formatDate(thread.createdAt)}',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.thumb_up,
                                        color: Colors.blue, size: 20),
                                    onPressed: () {
                                      debugPrint("You liked this Thread!");
                                    },
                                  ),
                                  const Text('Likes',
                                      style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint("CLICKED NEW THREAD");
          final _formKey = GlobalKey<FormState>();
          final _titleController = TextEditingController();
          final _contentController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create New Thread'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20), // Adding space between fields
                      TextFormField(
                        controller: _contentController,
                        maxLines: null, // Allowing multiline
                        keyboardType: TextInputType.multiline, // Enabling multiline keyboard
                        decoration: const InputDecoration(labelText: 'Content'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter content';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String title = _titleController.text;
                        final String content = _contentController.text;
                        final int userId = currentUser ?? 0;

                        try {
                          await createThread(title, content, userId);
                          Navigator.of(context).pop();
                          setState(() {
                            threads = getThread();
                          });
                        } catch (e) {
                          debugPrint('Error creating post: $e');
                          // Handle error
                        }
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
