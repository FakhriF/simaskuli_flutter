import 'package:flutter/material.dart';

class UpcomingQuiz extends StatelessWidget {
  const UpcomingQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        // height: 400,
        // padding: EdgeInsets.symmetric(horizontal: 20),
        // child: ListView(
        // shrinkWrap: false,
        // scrollDirection: Axis.vertical,
        Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          QuizWidget(),
          QuizWidget(
            courseTitle: "Aplikasi Berbasis Platform",
            description: "Quiz - Intro Flutter",
            color: Colors.blue,
          ),
          QuizWidget(
            courseTitle: "Sistem Basis Data",
            description: "Quiz - Skema Relasi & Unified Modelling Language",
            color: Colors.green,
          ),
          QuizWidget(
            courseTitle: "Bahasa Inggris Untuk Karir",
            description: "Quiz - Negotiate",
            color: Colors.yellow.shade700,
          ),
          QuizWidget(
            courseTitle: "Visualisasi Data",
            description: "Quiz - Negotiate",
            color: Colors.orange,
          ),
          // Container(
          //   width: 320,
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   padding: const EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.blue,
          //   ),
          //   child: const Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "APLIKASI BERBASIS PLATFORM",
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //         "Quiz - Intro Flutter",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white70,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   width: 320,
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   padding: const EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.green,
          //   ),
          //   child: const Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "SISTEM BASIS DATA",
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //         "Quiz - Skema Relasi & Unified Modelling Language",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white70,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   width: 320,
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   padding: const EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.yellow[700],
          //   ),
          //   child: const Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "BAHASA INGGRIS UNTUK KARIR",
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //         "Quiz - Negotiate",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white70,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   width: 320,
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   padding: const EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.orange,
          //   ),
          //   child: const Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "VISUALISASI DATA",
          //         style: TextStyle(
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //         "Quiz - Geoplotting",
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white70,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
    // ),
    // );
  }
}

class QuizWidget extends StatelessWidget {
  QuizWidget({
    this.courseTitle = "Judul Course",
    this.description = "Deskripsi Course",
    this.color = Colors.blue,
    super.key,
  });

  String courseTitle;
  String description;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
