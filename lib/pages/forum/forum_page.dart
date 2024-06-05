import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simaskuli/models/forum.dart';

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

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late Future<List<Thread>> threads;

  @override
  void initState() {
    super.initState();
    threads = getThread();
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(parsedDate);
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
                                debugPrint("You clicked on this thread!");
                              },
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.people,
                                  color: Colors.blue,
                                ),
                              ),
                              title: Text(
                                thread.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'By ${thread.userId}, ${formatDate(thread.createdAt)}',
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
        onPressed: () {
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO Add Push Function
                        Navigator.of(context).pop();
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
