import 'package:flutter/material.dart';
import 'package:simaskuli/controller/module_controller.dart';
import 'package:simaskuli/models/module.dart';
import 'package:url_launcher/url_launcher.dart';

class ModulePage extends StatefulWidget {
  final int courseId;

  const ModulePage({Key? key, required this.courseId}) : super(key: key);

  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  late Future<List<Module>> data;

  @override
  void initState() {
    super.initState();
    data = _fetchData();
    data.then((value) => print(value));
  }

  Future<List<Module>> _fetchData() async {
    return await ModuleController().getModule(widget.courseId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modules',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Module>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: snapshot.data!.map((module) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            width: double.infinity,
                            color: Color.fromARGB(255, 74, 202, 253),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              module.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ModuleCard(
                          learningOutcomes: module.learningAchievements != '-'
                              ? [module.learningAchievements]
                              : [],
                          materials: module.learningMaterials != '-'
                              ? [module.learningMaterials]
                              : [],
                          videosAndMaterials: [
                            if (module.videoLink.isNotEmpty)
                              VideoCard(
                                title: module.titleYoutube,
                                description: module.descriptionYoutube,
                                url: module.videoLink,
                              ),
                            if (module.noteLink.isNotEmpty)
                              VideoCard(
                                title: module.additionalMaterialTitle,
                                description:
                                    module.additionalMaterialDescription,
                                url: module.noteLink,
                              ),
                          ],
                          lectureNoteDescription: module.description,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const VideoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(url);
      },
      child: Card(
        color: Color.fromARGB(255, 202, 244, 250),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.video_collection,
                  size: 48, color: Color.fromARGB(255, 74, 202, 253)),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class ModuleCard extends StatelessWidget {
  final List<String> learningOutcomes;
  final List<String> materials;
  final List<VideoCard> videosAndMaterials;
  final String lectureNoteDescription;

  const ModuleCard({
    Key? key,
    required this.learningOutcomes,
    required this.materials,
    required this.videosAndMaterials,
    required this.lectureNoteDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capaian Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...learningOutcomes.map((outcome) => ListTile(
                  title: Text(outcome),
                )),
            const SizedBox(height: 8.0),
            const Text(
              'Materi Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...materials.map((material) => ListTile(
                  title: Text(material),
                )),
            const SizedBox(height: 8.0),
            const Text(
              'Video Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...videosAndMaterials
                .where((video) => video.title.isNotEmpty)
                .toList(),
            const SizedBox(height: 8.0),
            const Text(
              '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...videosAndMaterials
                .where((video) =>
                    video.title.isEmpty && video.description.isNotEmpty)
                .toList(),
            const SizedBox(height: 8.0),
            if (lectureNoteDescription.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lecture Note',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    lectureNoteDescription,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
