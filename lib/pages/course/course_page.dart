import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/controller/enrollment_controller.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/course/course_detail_page.dart';
import 'package:simaskuli/pages/course/course_create_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<List<Course>> _coursesFuture;
  final CourseController _courseController = CourseController();
  final EnrollmentController _enrollmentController = EnrollmentController();
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _coursesFuture = Future.value([]); // Initialize with an empty Future
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getInt('userId');
    });
    _fetchAllCourses();
  }

  Future<void> _fetchAllCourses() async {
    setState(() {
      _coursesFuture = _courseController.getCourses();
    });
  }

  Future<void> _fetchEnrolledCourses() async {
    if (_currentUserId != null) {
      setState(() {
        _coursesFuture = _enrollmentController.getByUserId(_currentUserId!);
      });
    }
  }

  Future<User?> _getUserById(int userId) async {
    try {
      return await _enrollmentController.getUserById(userId);
    } catch (e) {
      print('Failed to load user: $e');
      return null;
    }
  }

  String _truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length <= wordLimit) {
      return description;
    }
    return words.take(wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Course List'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _fetchAllCourses,
                    child: Text('Show All Courses'),
                  ),
                  ElevatedButton(
                    onPressed: _fetchEnrolledCourses,
                    child: Text('Show Enrolled Courses'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No courses found'));
                  } else {
                    final courses = snapshot.data!;
                    return ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return FutureBuilder<User?>(
                          future: _getUserById(course.userId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return _buildCourseCard(course, 'Loading lecturer...');
                            } else if (userSnapshot.hasError) {
                              return _buildCourseCard(course, 'Error loading lecturer');
                            } else if (!userSnapshot.hasData) {
                              return _buildCourseCard(course, 'Lecturer not found');
                            } else {
                              final user = userSnapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CourseDetailPage(course: course),
                                    ),
                                  );
                                },
                                child: _buildCourseCard(course, 'Lecturer: ${user.name}'),
                              );
                            }
                          },
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseCreatePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCourseCard(Course course, String lecturerInfo) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 4.0),
          Text(
            lecturerInfo,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
          const SizedBox(height: 8.0),
          Text(
            _truncateDescription(course.description, 20),
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
