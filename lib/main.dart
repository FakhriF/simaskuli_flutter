import 'package:flutter/material.dart';
import 'package:simaskuli/pages/intro/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simaskuli App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 240, 248, 255),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
