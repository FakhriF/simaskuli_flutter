import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simaskuli/controller/questions_controller.dart';
import 'package:simaskuli/models/user.dart';
import 'package:simaskuli/models/quiz.dart';
import 'package:simaskuli/controller/quiz_controller.dart';
import 'package:simaskuli/pages/course/quiz/question_create_page.dart';
import 'package:simaskuli/pages/course/quiz/question_page.dart';
import 'package:simaskuli/pages/course/quiz/quiz_edit_page.dart';

import 'package:simaskuli/pages/forum/forum_page.dart';
//import 'package:simaskuli/pages/grades/student_gradebook.dart';
import 'package:simaskuli/pages/profile/profile_page.dart';

import 'package:simaskuli/pages/course/course_page.dart';
import 'package:simaskuli/pages/course/course_selection.dart';

import 'package:simaskuli/pages/course/quiz/upcoming_quiz.dart';

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

  List<Widget> pages = [];

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

class DashboardPage extends StatefulWidget {
  const DashboardPage({required this.userData, super.key});

  final User userData;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Quiz>> _quizzesFuture;
  final QuestionsController _questionsController = QuestionsController();
  final QuizController _quizController = QuizController();
  late List<Quiz> _quizzes;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = _fetchQuizzes();
  }

  Future<List<Quiz>> _fetchQuizzes() async {
    _quizzes = await _quizController.getQuiz();
    return _quizzes;
    // return await _questionsController.getQuiz();
  }

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

  void _addQuestion(int quizId) {
    // Handle add question action
    try {
      if (quizId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionsCreatePage(
              quizId: quizId,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit quiz: $e')),
      );
    }
  }

  void _editQuiz(Quiz quiz) async {
    try {
      //final quiz = await _quizController.getQuizById(quizId);
      if (quiz != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizUpdatePage(quiz: quiz),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit quiz: $e')),
      );
    }
  }

  void _deleteQuiz(int quizId) async {
    try {
      await _quizController.deleteQuiz(quizId);
      setState(() {
        _quizzes.removeWhere((quiz) => quiz.id == quizId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete quiz: $e')),
      );
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
                          widget.userData.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(widget.userData.profileUrl),
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
              Container(
                padding: const EdgeInsets.all(24),
                child: const Text(
                  "Upcoming Quiz",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<List<Quiz>>(
                future: _quizzesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No quizzes available.'));
                  }

                  final quizzes = snapshot.data!;
                  return UpcomingQuiz(
                    quizzes: quizzes,
                    onQuizSelected: (quizId) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizQuestionsPage(quizId: quizId),
                        ),
                      );
                    },
                    onAddQuestion: _addQuestion,
                    onEditQuiz: _editQuiz,
                    onDeleteQuiz: _deleteQuiz,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
