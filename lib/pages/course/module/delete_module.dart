import 'package:flutter/material.dart';
import 'package:simaskuli/controller/module_controller.dart';

class DeleteModulePage extends StatefulWidget {
  final int courseId;

  const DeleteModulePage({Key? key, required this.courseId}) : super(key: key);

  @override
  _DeleteModulePageState createState() => _DeleteModulePageState();
}

class _DeleteModulePageState extends State<DeleteModulePage> {
  final _moduleIdController = TextEditingController();
  final _moduleController = ModuleController();

  Future<void> _deleteModule() async {
    final moduleId = int.tryParse(_moduleIdController.text);
    if (moduleId != null) {
      try {
        await _moduleController.deleteModule(widget.courseId, moduleId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Module deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete module: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid module ID')),
      );
    }
  }

  @override
  void dispose() {
    _moduleIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _moduleIdController,
              decoration: InputDecoration(labelText: 'Module ID'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteModule,
              child: Text('Delete Module'),
            ),
          ],
        ),
      ),
    );
  }
}
