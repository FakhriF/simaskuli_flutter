import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/course.dart';

class CourseCreatePage extends StatefulWidget {
  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State<CourseCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _learningOutcomesController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final CourseController _courseController = CourseController();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
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
                controller: _learningOutcomesController,
                decoration: InputDecoration(labelText: 'Learning Outcomes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the learning outcomes';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
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
                child: Text('Create Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createCourse() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user ID')),
      );
      return;
    }

    Course newCourse = Course(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      learningOutcomes: _learningOutcomesController.text,
      imageUrl: _imageUrlController.text,
      userId: _userId!,
    );

    try {
      Course createdCourse = await _courseController.createCourse(newCourse);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course created: ${createdCourse.title}')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create course: $e')),
      );
    }
  }
}
