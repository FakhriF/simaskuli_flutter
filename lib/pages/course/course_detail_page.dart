import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/user.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  CourseDetailPage({super.key, required this.course});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final CourseController _courseController = CourseController();
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getInt('userId');
    });
  }

  Future<User?> _getUserById(int userId) async {
    try {
      return await _courseController.getUserById(userId);
    } catch (e) {
      print('Failed to load user: $e');
      return null;
    }
  }

  void _deleteCourse() async {
    final confirmed = await _showConfirmationDialog();
    if (confirmed) {
      try {
        await _courseController.deleteCourse(widget.course.id);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: $e')),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this course?'),
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
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.course.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<User?>(
                future: _getUserById(widget.course.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading lecturer...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]));
                  } else if (snapshot.hasError) {
                    return Text('Error loading lecturer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red));
                  } else if (!snapshot.hasData) {
                    return Text('Lecturer not found',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red));
                  } else {
                    final user = snapshot.data!;
                    return Text('Lecturer: ${user.name}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]));
                  }
                },
              ),
              const SizedBox(height: 16.0),
              if (widget.course.imageUrl.isNotEmpty)
                Image.network(
                  widget.course.imageUrl,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16.0),
              Text(
                widget.course.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Learning Outcomes: ${widget.course.learningOutcomes}',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Tambahkan aksi yang ingin dilakukan saat tombol ditekan di sini
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    child: Text(
                      'Create Quiz',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentUserId == widget.course.userId
          ? FloatingActionButton(
              onPressed: _deleteCourse,
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
