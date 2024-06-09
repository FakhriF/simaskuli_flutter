import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/course_controller.dart';
import 'package:simaskuli/models/course.dart';

class CourseUpdatePage extends StatefulWidget {
  final Course course;

  CourseUpdatePage({super.key, required this.course});

  @override
  _CourseUpdatePageState createState() => _CourseUpdatePageState();
}

class _CourseUpdatePageState extends State<CourseUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _learningOutcomesController;
  late TextEditingController _imageUrlController;

  final CourseController _courseController = CourseController();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
    _descriptionController = TextEditingController(text: widget.course.description);
    _learningOutcomesController = TextEditingController(text: widget.course.learningOutcomes);
    _imageUrlController = TextEditingController(text: widget.course.imageUrl);
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
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
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Course'),
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateCourse();
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteCourse,
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _updateCourse() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user ID')),
      );
      return;
    }

    String imageUrl = _imageUrlController.text.isNotEmpty
        ? _imageUrlController.text
        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/640px-Google_2015_logo.svg.png';

    Course updatedCourse = Course(
      id: widget.course.id,
      title: _titleController.text,
      description: _descriptionController.text,
      learningOutcomes: _learningOutcomesController.text,
      imageUrl: imageUrl,
      userId: widget.course.userId,
    );

    try {
      Course editedCourse = await _courseController.updateCourse(updatedCourse);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course updated: ${editedCourse.title}')),
      );
      Navigator.pop(context, editedCourse);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update course: $e')),
      );
    }
  }
}
