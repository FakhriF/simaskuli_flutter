import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/models/user.dart';

import 'package:simaskuli/pages/forum/forum_page.dart';
import 'package:simaskuli/pages/grades/student_gradebook.dart';
import 'package:simaskuli/pages/profile/profile_page.dart';

import 'package:simaskuli/pages/course/course_page.dart';
import 'package:simaskuli/pages/course/course_selection.dart';

import 'package:simaskuli/pages/course/upcoming_quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  Future<User> getUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt('userId');
      final user = prefs.getString('userName');
      final email = prefs.getString('email');
      final role = prefs.getString('role');
      final profileUrl = prefs.getString('profile_url');
      final birthDate = prefs.getString('birth_date');

      print(
          'User Data Retrieved: $userId, $user, $email, $role, $profileUrl, $birthDate');

      return User(
        id: userId ?? 0,
        name: user ?? '',
        email: email ?? '',
        role: role ?? '',
        profileUrl: profileUrl ??
            "https://cdn.picrew.me/shareImg/org/202404/1904634_70voI7cp.png",
        birthDate: birthDate ?? '',
      );
    } catch (e) {
      print('Error retrieving user data: $e');
      return User(
        id: 0,
        name: '',
        email: '',
        role: '',
        profileUrl:
            "https://cdn.picrew.me/shareImg/org/202404/1904634_70voI7cp.png",
        birthDate: '',
      );
    }
  }

  Future<void> _initializePages() async {
    final user = await getUserData();
    final dashboardPage = DashboardPage(userData: user);
    final otherPages = [
      const CoursePage(), //TODO: Ubah ini menjadi halaman kursus
      const ForumPage(), //TODO: Ubah ini menjadi halaman forum
      ProfilePage(userData: user),
    ];
    setState(() {
      pages = [dashboardPage, ...otherPages];
    });
  }

  List<Widget> pages = [
    // const DashboardPage(),
    // const Center(
    //     child: Text("Course Page")), //TODO: Change this to the Course Page
    // const ForumPage(), //TODO: Change this to the Forum Page
    // const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.isNotEmpty ? pages[currentPage] : Container(),
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
  const DashboardPage({required this.userData, super.key});

  final User userData;

  static List<String> greetings = [
    'Good Morning',
    'Good Afternoon',
    'Good Evening',
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return greetings[0];
    } else if (hour < 18) {
      return greetings[1];
    } else {
      return greetings[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${getGreeting()},"),
                        Text(
                          userData.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(userData.profileUrl),
                    ),
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
              CourseSelection(),
              //TODO: Implement Courses in Dashboard Here!
              Container(
                padding: const EdgeInsets.all(24),
                child: const Text(
                  "Upcoming Quiz",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              //TODO: Implement Upcoming Quiz in Dashboard Here!
              const UpcomingQuiz()
              //TODO: See the reference design here https://dribbble.com/shots/16244904-Education-Online-Course-Mobile-App
            ],
          ),
        ),
      ),
    );
  }
}
