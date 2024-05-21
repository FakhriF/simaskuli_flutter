import 'package:flutter/material.dart';
import 'package:simaskuli/controller/token_controller.dart';
import 'package:simaskuli/controller/user_auth_controller.dart';
import 'package:simaskuli/pages/home_page.dart';
import 'package:simaskuli/pages/intro/intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initializePages();
    super.initState();
  }

  Future<void> _initializePages() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await getToken();

    if (token != null) {
      await loadUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IntroPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SIMASKULI',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 16.0),
              CircularProgressIndicator(
                strokeWidth: 1.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
