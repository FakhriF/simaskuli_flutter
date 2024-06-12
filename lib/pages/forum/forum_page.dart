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

  Future<void> _deleteThread(int threadId) async {
    final endpoint = 'https://simaskuli-api.vercel.app/api/api/forum/$threadId';

    final response = await http.delete(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      debugPrint('Thread deleted successfully');
      setState(() {
        threads = threads.then((list) => list.where((thread) => thread.id != threadId).toList());
      });
    } else {
      throw Exception('Failed to delete thread: ${response.statusCode}');
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

  void _showThreadMenu(BuildContext context, Thread thread) {
    final isCurrentUserThread = thread.user.id == currentUser;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.thumb_up, color: Colors.blue),
                title: const Text('Like'),
                onTap: () {
                  debugPrint("You liked this Thread!");
                  Navigator.pop(context);
                },
              ),
              if (isCurrentUserThread)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Are you sure you want to delete this thread?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteThread(thread.id);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum')
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            threads = getThread();
          });
        },
        child: FutureBuilder<List<Thread>>(
          future: threads,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No threads found.'));
            } else {
              List<Thread> threads = snapshot.data!;
              return ListView.separated(
                itemCount: threads.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  Thread thread = threads[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThreadPage(thread: thread),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(thread.user.profileUrl),
                    ),
                    title: Text(
                      thread.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'By ${thread.user.name}, ${formatDate(thread.createdAt)}',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        _showThreadMenu(context, thread);
                      },
                    ),
                  );
                },
              );
            }
          },
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
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
