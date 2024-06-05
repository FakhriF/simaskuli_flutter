import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Introduction to Programming'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ModuleCard(
                  title: 'Module 01: Introduction to Web Programming & HTML',
                  learningOutcomes: [
                    'Mahasiswa mampu menjelaskan konsep dasar web dan arsitektur web',
                    'Mahasiswa mampu membuat dokumen HTML yang sesuai dengan standar W3C'
                  ],
                  materials: [
                    'Pengenalan Teknologi Web',
                    'Web Server',
                    'Syntax HTML',
                    'Elemen-elemen standar pada HTML'
                  ],
                  videosAndMaterials: [
                    VideoCard(
                      title: 'Teknologi Web',
                      description: 'Pengantar tentang teknologi web dasar',
                      url:
                          'https://www.youtube.com/watch?v=maZbxkpZIGw&pp=ygUNdGVrbm9sb2dpIHdlYg%3D%3D',
                    ),
                    VideoCard(
                      title: 'Materi HTML, XML dan JSON',
                      description: 'Penjelasan mengenai HTML, XML, dan JSON',
                      url:
                          'https://www.youtube.com/watch?v=I0Y2oyBmv6Q&list=PLc3SzDYhhiGVk_t12M_vNTGU322C3s-d0',
                    ),
                  ],
                  lectureNoteUrl:
                      'https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/HTML_basics',
                  lectureNoteTitle: 'Lecture Note Week 1',
                  lectureNoteDescription:
                      'HTML (HyperText Markup Language) adalah kode yang digunakan untuk menyusun halaman web dan kontennya. Misalnya, konten dapat disusun dalam sekumpulan paragraf, daftar poin-poin, atau menggunakan gambar dan tabel data. Sesuai dengan judulnya, artikel ini akan memberikan Anda pemahaman dasar tentang HTML dan fungsinya.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String title;
  final List<String> learningOutcomes;
  final List<String> materials;
  final List<VideoCard> videosAndMaterials;
  final String lectureNoteUrl;
  final String lectureNoteTitle;
  final String lectureNoteDescription;

  const ModuleCard({super.key, 
    required this.title,
    required this.learningOutcomes,
    required this.materials,
    required this.videosAndMaterials,
    required this.lectureNoteUrl,
    required this.lectureNoteTitle,
    required this.lectureNoteDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Capaian Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...learningOutcomes.map((outcome) => ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(outcome),
                )),
            const SizedBox(height: 8.0),
            const Text(
              'Materi Pembelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...materials.map((material) => ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(material),
                )),
            const SizedBox(height: 8.0),
            const Text(
              'Video & Materi Lainnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...videosAndMaterials,
            const SizedBox(height: 8.0),
            Text(
              lectureNoteTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              lectureNoteDescription,
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {},
              child: Text(
                lectureNoteUrl,
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const VideoCard({super.key, 
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement onTap to open the video URL
      },
      child: Card(
        color: Colors.grey[200],
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.video_collection, size: 48, color: Colors.grey[700]),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(description),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
