import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/course/course_update_page.dart';
import 'package:simaskuli/pages/course_building_map/course_building_map.dart';
import 'package:simaskuli/pages/grades/student_gradebook.dart';

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
              const SizedBox(height: 16.0), // Add spacing between course details and the button
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
                      builder: (context) => CourseUpdatePage(course: widget.course),
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
