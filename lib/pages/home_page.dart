import 'package:flutter/material.dart';
import 'package:simaskuli/pages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = 0;

  List<Widget> pages = [
    const DashboardPage(),
    const Center(
        child: Text("Course Page")), //TODO: Change this to the Course Page
    const Center(
        child: Text("Forum Page")), //TODO: Change this to the Forum Page
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        onTap: (value) => setState(() => currentPage = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_rounded),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hai,"),
                      Text(
                        "User Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                  CircleAvatar(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: const Text(
                "Courses",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            //TODO: Implement Course in Dashboard Here!
            //TODO: See the reference design here https://dribbble.com/shots/16244904-Education-Online-Course-Mobile-App
          ],
        ),
      ),
    );
  }
}
