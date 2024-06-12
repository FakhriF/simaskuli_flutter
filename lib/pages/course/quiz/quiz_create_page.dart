import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/quiz_controller.dart';
import 'package:simaskuli/models/quiz.dart';

class CourseCreatePage extends StatefulWidget {
  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<CourseCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  final QuizController _quizController = QuizController();
  int? _courseId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _courseId = prefs.getInt('courseId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(labelText: 'Due Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the learning outcomes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createCourse();
                  }
                },
                child: Text('Create Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCourse() async {
    if (_courseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load course ID')),
      );
      return;
    }

    Quiz newQuiz = Quiz(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDateController.text,
      courseId: _courseId!,
    );

    try {
      Quiz createdQuiz = await _quizController.createQuiz(newQuiz);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course created: ${createdQuiz.title}')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create course: $e')),
      );
    }
  }
}
