import 'package:flutter/material.dart';
import 'package:simaskuli/controller/module_controller.dart';
import 'package:simaskuli/models/module.dart';

class UpdateModulePage extends StatefulWidget {
  final int courseId;
  final Module module;

  const UpdateModulePage(
      {Key? key, required this.courseId, required this.module})
      : super(key: key);

  @override
  _UpdateModulePageState createState() => _UpdateModulePageState();
}

class _UpdateModulePageState extends State<UpdateModulePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _learningAchievementsController;
  late TextEditingController _learningMaterialsController;
  late TextEditingController _titleYoutubeController;
  late TextEditingController _descriptionYoutubeController;
  late TextEditingController _additionalMaterialTitleController;
  late TextEditingController _additionalMaterialDescriptionController;
  late TextEditingController _descriptionController;
  late TextEditingController _videoLinkController;
  late TextEditingController _noteLinkController;
  final _moduleController = ModuleController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.module.title);
    _learningAchievementsController =
        TextEditingController(text: widget.module.learningAchievements);
    _learningMaterialsController =
        TextEditingController(text: widget.module.learningMaterials);
    _titleYoutubeController =
        TextEditingController(text: widget.module.titleYoutube);
    _descriptionYoutubeController =
        TextEditingController(text: widget.module.descriptionYoutube);
    _additionalMaterialTitleController =
        TextEditingController(text: widget.module.additionalMaterialTitle);
    _additionalMaterialDescriptionController = TextEditingController(
        text: widget.module.additionalMaterialDescription);
    _descriptionController =
        TextEditingController(text: widget.module.description);
    _videoLinkController = TextEditingController(text: widget.module.videoLink);
    _noteLinkController = TextEditingController(text: widget.module.noteLink);
  }

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

  Future<void> _updateModule() async {
    if (_formKey.currentState!.validate()) {
      final updatedModule = Module(
        id: widget.module.id,
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
        await _moduleController.updateModule(updatedModule);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Module updated successfully')),
        );
        Navigator.pop(context); // Close the page after update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update module: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Module'),
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
                onPressed: _updateModule,
                child: Text('Update Module'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
