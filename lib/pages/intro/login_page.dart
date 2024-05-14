import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simaskuli/pages/intro/fetch_demo_page.dart';
import 'package:simaskuli/pages/home_page.dart';
import 'package:simaskuli/pages/intro/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SIMASKULI',
                    style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Log in to\nSimaskuli',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 5,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        const SizedBox(width: 8.0),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //TODO: COMMENT/UNCOMMENT CODE BELOW LATER
                    // TextButton(
                    //   onPressed: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const MyApp(),
                    //     ),
                    //   ),
                    //   child: const Text('Fetch Demo'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
