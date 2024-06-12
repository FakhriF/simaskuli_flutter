import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simaskuli/models/forum.dart';
import 'package:simaskuli/models/thread.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ThreadPage extends StatefulWidget {
  final Thread thread;

  const ThreadPage({Key? key, required this.thread}) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final TextEditingController _replyController = TextEditingController();
  bool _isReplying = false;
  List<ThreadPost> _replies = [];
  int? currentUser;

  String? _editedContent; // Add this line
  ThreadPost? _replyBeingEdited; // Add this line


  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getInt('userId') ?? 0;
    });
  }

  Future<List<ThreadPost>> fetchReplies() async {
    final response = await http.get(Uri.parse('https://simaskuli-api.vercel.app/api/api/forum/${widget.thread.id}/posts'));

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

  Future<void> postReply() async {
    final String content = _replyController.text.trim();
    if (content.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://simaskuli-api.vercel.app/api/api/forum/${widget.thread.id}/posts'),
          body: json.encode({
            'content': content,
            'thread_id': widget.thread.id,
            'user_id': currentUser,
          }),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 201) {
          debugPrint('Reply submitted successfully');
          _replyController.clear();
          setState(() {
            _isReplying = false;
          });
          // Refresh the replies list
          setState(() {});
        } else {
          debugPrint('Error submitting reply: ${response.body}');
        }
      } catch (error) {
        debugPrint('Error submitting reply: $error');
      }
    }
  }

  void editReply(ThreadPost reply) {
    _replyBeingEdited = reply; // Store the reply being edited
    _editedContent = reply.content; // Initialize the edited content with the current reply content

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reply'),
          content: TextField(
            controller: TextEditingController(text: _editedContent),
            onChanged: (value) {
              setState(() {
                _editedContent = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _replyBeingEdited = null; // Reset the reply being edited
                _editedContent = null; // Reset the edited content
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveEditedReply();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // TODO: NOT CURRENTLY WORKING

  Future<void> saveEditedReply() async {
    if (_editedContent != null && _replyBeingEdited != null) {
      try {
        final response = await http.put(
          Uri.parse('https://simaskuli-api.vercel.app/api/api/forum/${widget.thread.id}/posts/${_replyBeingEdited!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'content': _editedContent}),
        );

        if (response.statusCode == 200) {
          debugPrint('Reply updated successfully');
          setState(() {
            final updatedIndex = _replies.indexWhere((reply) => reply.id == _replyBeingEdited!.id);
            _replies[updatedIndex].content = _editedContent!;
          });
        } else {
          debugPrint('Failed to update reply: ${response.statusCode}');
        }
      } catch (error) {
        debugPrint('Error updating reply: $error');
      } finally {
        _replyBeingEdited = null;
        _editedContent = null;
      }
    }
  }

  Future<void> deleteReply(ThreadPost reply) async {
    bool shouldDelete = await showConfirmationDialog(context, reply);
    if (shouldDelete) {
      try {
        final response = await http.delete(
          Uri.parse('https://simaskuli-api.vercel.app/api/api/forum/${widget.thread.id}/posts/${reply.id}'),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          debugPrint('Reply deleted successfully');
          setState(() {
            _replies = _replies.where((r) => r.id != reply.id).toList();
          });
        } else {
          debugPrint('Error deleting reply: ${response.body}');
        }
      } catch (error) {
        debugPrint('Error deleting reply: $error');
      }
    }
  }

  Future<bool> showConfirmationDialog(BuildContext context, ThreadPost reply) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this reply?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }


  String formatTimeDifference(String dateString) {
    final DateTime postDate = DateTime.parse(dateString);
    final Duration difference = DateTime.now().difference(postDate);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
  //
  // void editReply(ThreadPost reply) {
  //   // Implement edit reply functionality
  //   debugPrint('Edit reply: ${reply.id}');
  // }

  // void deleteReply(ThreadPost reply) {
  //   // Implement delete reply functionality
  //   debugPrint('Delete reply: ${reply.id}');
  // }


  void showOptionsBottomSheet(BuildContext context, ThreadPost reply) {
    final isCurrentUser = reply.userId == currentUser;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrentUser) ...[
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    editReply(reply);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red,),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    deleteReply(reply);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: Icon(Icons.reply, color: Colors.blue),
                  title: Text('Reply'),
                  onTap: () {
                    Navigator.pop(context);
                    // replyToPost(reply);
                  },
                ),
              ],
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
              subtitle: Text(formatTimeDifference(widget.thread.createdAt)),
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
                      final isCurrentUser = reply.userId == currentUser;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(reply.user.profileUrl),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(reply.user.name),
                            Text(
                              formatTimeDifference(reply.createdAt),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        subtitle: Text(reply.content),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () => showOptionsBottomSheet(context, reply),
                          ),
                      );
                    },
                  );
                }
              },
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Post a new reply...',
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        setState(() {
                          _isReplying = true;
                        });
                      },
                    ),
                  ),
                  if (_isReplying)
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: postReply,
                    ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}