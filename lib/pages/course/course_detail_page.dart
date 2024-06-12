import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/controller/enrollment_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/course/course_update_page.dart';
import 'package:simaskuli/pages/course_building_map/course_building_map.dart';
import 'package:simaskuli/pages/grades/student_gradebook.dart';
import 'package:simaskuli/pages/course/quiz/quiz_create_page.dart';

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
      bool isEnrolled = await _enrollmentController.isEnrolled(
          _currentUserId!, widget.course.id);
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
              const SizedBox(height: 8.0),
              if (_currentUserId != widget.course.userId)
                _isEnrolled
                    ? ElevatedButton.icon(
                        onPressed: _unenroll,
                        icon: Icon(Icons.cancel),
                        label: Text('Unenroll'),
                      )
                    : ElevatedButton.icon(
                        onPressed: _enroll,
                        icon: Icon(Icons.add),
                        label: Text('Enroll'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizCreatePage(courseId: widget.course.id),
                      ),
                    );
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
              const SizedBox(
                  height:
                      16.0), // Add spacing between course details and the button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPage(
                        courseId: widget.course.id,
                      ),
                    ),
                  );
                },
                child: Text('View Course Building Map'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_currentUserId == widget.course.userId)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseUpdatePage(course: widget.course),
                    ),
                  );
                },
                child: Icon(Icons.edit),
              ),
            ),
          Positioned(
            bottom: 16.0,
            right: _currentUserId == widget.course.userId ? 80.0 : 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentGradeBook(
                      courseId: widget.course.id,
                      userId: _currentUserId!,
                    ),
                  ),
                );
              },
              child: Icon(Icons.book),
            ),
          ),
          // Positioned(
          //   bottom: 16.0,
          //   left: 16.0,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MapsPage(
          //             courseId: widget.course.id,
          //           ),
          //         ),
          //       );
          //     },
          //     child: Icon(Icons.map),
          //   ),
          // ),
        ],
      ),
    );
  }
}
