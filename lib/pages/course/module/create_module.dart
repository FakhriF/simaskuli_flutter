import 'package:flutter/material.dart';
import 'package:simaskuli/controller/module_controller.dart';
import 'package:simaskuli/models/module.dart';

class CreateModulePage extends StatefulWidget {
  final int courseId;

  const CreateModulePage({Key? key, required this.courseId}) : super(key: key);

  @override
  _CreateModulePageState createState() => _CreateModulePageState();
}

class _CreateModulePageState extends State<CreateModulePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _learningAchievementsController = TextEditingController();
  final _learningMaterialsController = TextEditingController();
  final _titleYoutubeController = TextEditingController();
  final _descriptionYoutubeController = TextEditingController();
  final _additionalMaterialTitleController = TextEditingController();
  final _additionalMaterialDescriptionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _videoLinkController = TextEditingController();
  final _noteLinkController = TextEditingController();
  final _moduleController = ModuleController();

  @override
  void dispose() {
    _titleController.dispose();
    _learningAchievementsController.dispose();
    _learningMaterialsController.dispose();
    _titleYoutubeController.dispose();
    _descriptionYoutubeController.dispose();
    _additionalMaterialTitleController.dispose();
    _additionalMaterialDescriptionController.dispose();
    _descriptionController.dispose();
    _videoLinkController.dispose();
    _noteLinkController.dispose();
    super.dispose();
  }

  Future<void> _createModule() async {
    if (_formKey.currentState!.validate()) {
      final newModule = Module(
        id: 0, // Assuming the backend will generate the ID
        courseId: widget.courseId,
        title: _titleController.text,
        learningAchievements: _learningAchievementsController.text,
        learningMaterials: _learningMaterialsController.text,
        titleYoutube: _titleYoutubeController.text,
        descriptionYoutube: _descriptionYoutubeController.text,
        additionalMaterialTitle: _additionalMaterialTitleController.text,
        additionalMaterialDescription:
            _additionalMaterialDescriptionController.text,
        description: _descriptionController.text,
        videoLink: _videoLinkController.text,
        noteLink: _noteLinkController.text,
      );

      try {
        await _moduleController.createModule(newModule);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Module created successfully')),
        );
        Navigator.pop(context); // Close the page after creation
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create module: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Module'),
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
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              TextFormField(
                controller: _learningAchievementsController,
                decoration: InputDecoration(labelText: 'Learning Achievements'),
                validator: (value) => value!.isEmpty
                    ? 'Learning Achievements cannot be empty'
                    : null,
              ),
              TextFormField(
                controller: _learningMaterialsController,
                decoration: InputDecoration(labelText: 'Learning Materials'),
                validator: (value) => value!.isEmpty
                    ? 'Learning Materials cannot be empty'
                    : null,
              ),
              TextFormField(
                controller: _titleYoutubeController,
                decoration: InputDecoration(labelText: 'YouTube Title'),
              ),
              TextFormField(
                controller: _descriptionYoutubeController,
                decoration: InputDecoration(labelText: 'YouTube Description'),
              ),
              TextFormField(
                controller: _additionalMaterialTitleController,
                decoration:
                    InputDecoration(labelText: 'Additional Material Title'),
              ),
              TextFormField(
                controller: _additionalMaterialDescriptionController,
                decoration: InputDecoration(
                    labelText: 'Additional Material Description'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              TextFormField(
                controller: _videoLinkController,
                decoration: InputDecoration(labelText: 'Video Link'),
              ),
              TextFormField(
                controller: _noteLinkController,
                decoration: InputDecoration(labelText: 'Note Link'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createModule,
                child: Text('Create Module'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
