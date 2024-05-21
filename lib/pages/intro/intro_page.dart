import 'package:flutter/material.dart';
import 'package:simaskuli/pages/intro/login_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  var currentIntro = 0;

  List<dynamic> intro = [
    [
      const Text(
        'SIMASKULI',
        style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent),
      ),
      const Text(
        "Welcome to Simaskuli-App!",
        style: TextStyle(fontSize: 18.0),
      ),
    ],
    [
      Center(
        child: Image.asset("assets/images/Learning_Rafiki.png", height: 400),
      ),
      const Text(
        "In this app, you will learn many things. Are you ready?",
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              intro[currentIntro][0],
              const SizedBox(height: 32.0),
              intro[currentIntro][1],
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (currentIntro + 1 == intro.length) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } else {
                    setState(() {
                      currentIntro++;
                    });
                  }
                },
                child: currentIntro == 1
                    ? const Text('Let\'s Start')
                    : const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
