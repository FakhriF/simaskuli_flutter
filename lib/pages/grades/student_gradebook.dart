import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/grade_controller.dart';
import 'package:simaskuli/models/course.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/grade.dart';
import 'package:simaskuli/models/user.dart';

class StudentGradeBook extends StatefulWidget {
  final int courseId;
  final int userId;

  StudentGradeBook({required this.courseId, required this.userId});

  @override
  State<StudentGradeBook> createState() => _StudentGradeBookState();
}

class _StudentGradeBookState extends State<StudentGradeBook> {
  String studentName = 'Loading...';
  String studentGrade = 'Loading...';
  List<Grade> subjects = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await CourseController().getUserById(widget.userId);
      final grades = await GradesController().getQuizData(widget.courseId, widget.userId); // Fetching quiz data for the course
      setState(() {
        studentName = user.name;
        studentGrade = _calculateAverageGrade(grades); // Calculate average grade from quizzes
        subjects = grades; // Assign fetched grades to subjects
      });
    } catch (e) {
      print('Failed to load user: $e');
    }
  }

  String _calculateAverageGrade(List<Grade> grades) {
    if (grades.isEmpty) return 'N/A';
    final totalGrade = grades.map((grade) => grade.grade).reduce((a, b) => a + b);
    final averageGrade = totalGrade / grades.length;
    return averageGrade.toStringAsFixed(2); // Format to 2 decimal places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text('Student Grade Book', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: $studentName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Grade: $studentGrade',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Subjects:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        subjects[index].quizTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          subjects[index].grade.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
