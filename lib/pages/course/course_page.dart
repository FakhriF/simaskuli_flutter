import 'package:flutter/material.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/pages/course/course_detail_page.dart';
import 'package:simaskuli/pages/course/course_create_page.dart';

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  late Future<List<Course>> _coursesFuture;
  final CourseController _courseController = CourseController();

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseController.getCourses();
  }

  Future<User?> _getUserById(int userId) async {
    try {
      return await _courseController.getUserById(userId);
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
        title: const Text('Course List'),
      ),
      body: SafeArea(
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 4.0),
          Text(
            lecturerInfo,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
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
