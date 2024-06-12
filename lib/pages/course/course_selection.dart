import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/enrollment_controller.dart';
import 'course_detail_page.dart'; // Import the CourseDetailPage

class CourseSelection extends StatefulWidget {
  const CourseSelection({super.key});

  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection> {
  final EnrollmentController _enrollmentController = EnrollmentController();
  List<Course> _enrolledCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEnrolledCourses();
  }

  Future<void> _fetchEnrolledCourses() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      if (userId != null) {
        List<Course> courses = await _enrollmentController.getByUserId(userId);
        if (mounted) { // Check if the widget is still mounted
          setState(() {
            _enrolledCourses = courses;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Failed to load enrolled courses: $e');
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length <= wordLimit) {
      return description;
    }
    return words.take(wordLimit).join(' ') + '...';
  }

  void _onCourseTap(Course course) {
    // Navigate to the CourseDetailPage with the course data
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = _enrolledCourses[index];
                return GestureDetector(
                  onTap: () => _onCourseTap(course),
                  child: Container(
                    width: 320,
                    margin: EdgeInsets.only(left: index == 0 ? 20 : 10, right: index == _enrolledCourses.length - 1 ? 20 : 0),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF3d5094), // Set background color to #3d5094
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _truncateDescription(course.description, 15), // Truncate description with word limit
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
