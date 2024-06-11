import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/controller/enrollment_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/course/course_update_page.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  CourseDetailPage({super.key, required this.course});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final CourseController _courseController = CourseController();
  final EnrollmentController _enrollmentController = EnrollmentController();
  int? _currentUserId;
  bool _isEnrolled = false;

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
    if (_currentUserId != null) {
      _checkEnrollment();
    }
  }

  Future<void> _checkEnrollment() async {
    try {
      bool isEnrolled = await _enrollmentController.isEnrolled(_currentUserId!, widget.course.id);
      setState(() {
        _isEnrolled = isEnrolled;
      });
    } catch (e) {
      print('Failed to check enrollment: $e');
    }
  }

  Future<User?> _getUserById(int userId) async {
    try {
      return await _courseController.getUserById(userId);
    } catch (e) {
      print('Failed to load user: $e');
      return null;
    }
  }

  Future<void> _enroll() async {
    try {
      await _enrollmentController.store(_currentUserId!, widget.course.id);
      setState(() {
        _isEnrolled = true;
      });
    } catch (e) {
      print('Failed to enroll: $e');
    }
  }

  Future<void> _unenroll() async {
    try {
      await _enrollmentController.destroy(_currentUserId!, widget.course.id);
      setState(() {
        _isEnrolled = false;
      });
    } catch (e) {
      print('Failed to unenroll: $e');
    }
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<User?>(
                future: _getUserById(widget.course.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading lecturer...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]));
                  } else if (snapshot.hasError) {
                    return Text('Error loading lecturer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
                  } else if (!snapshot.hasData) {
                    return Text('Lecturer not found', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
                  } else {
                    final user = snapshot.data!;
                    return Text('Lecturer: ${user.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]));
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
              if (_currentUserId != widget.course.userId)
                _isEnrolled
                  ? ElevatedButton(
                      onPressed: _unenroll,
                      child: Text('Unenroll'),
                    )
                  : ElevatedButton(
                      onPressed: _enroll,
                      child: Text('Enroll'),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentUserId == widget.course.userId
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseUpdatePage(course: widget.course),
                  ),
                );
              },
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}
