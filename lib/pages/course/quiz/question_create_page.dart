import 'package:flutter/material.dart';
import 'package:simaskuli/models/questions.dart';
import 'package:simaskuli/controller/questions_controller.dart';

class QuestionsCreatePage extends StatefulWidget {
  final int quizId;
  const QuestionsCreatePage({required this.quizId});

  @override
  _QuestionsCreatePageState createState() => _QuestionsCreatePageState();
}

class _QuestionsCreatePageState extends State<QuestionsCreatePage> {
  late Future<List<Questions>> _questionsFuture;
  final QuestionsController _questionsController = QuestionsController();
  Map<int, String> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions();
  }

  Future<List<Questions>> _fetchQuestions() async {
    return await _questionsController.getQuestionsByQuizId(widget.quizId);
  }

  Future<void> _refreshQuestions() async {
    setState(() {
      _questionsFuture = _fetchQuestions();
    });
  }

  void _showQuestionForm({Questions? question}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(question == null ? 'Add Question' : 'Edit Question'),
          content: QuestionForm(
            question: question,
            quizId: widget.quizId,
            onSave: (Questions updatedQuestion) async {
              if (question == null) {
                await _questionsController.createQuestion(updatedQuestion);
              } else {
                await _questionsController.editQuestion(updatedQuestion);
              }
              _refreshQuestions();
            },
          ),
        );
      },
    );
  }

  void _deleteQuestion(int id) async {
    await _questionsController.deleteQuestion(id);
    _refreshQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showQuestionForm(),
          ),
        ],
      ),
      body: FutureBuilder<List<Questions>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          final questions = snapshot.data!;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(question.question_text,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      RadioListTile<String>(
                        title: Text(question.option1),
                        value: question.option1,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option2),
                        value: question.option2,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option3),
                        value: question.option3,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(question.option4),
                        value: question.option4,
                        groupValue: _selectedAnswers[question.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[question.id] = value!;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                _showQuestionForm(question: question),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteQuestion(question.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuestionForm extends StatefulWidget {
  final Questions? question;
  final int quizId;
  final Function(Questions) onSave;

  QuestionForm({this.question, required this.quizId, required this.onSave});

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionTextController;
  late TextEditingController _option1Controller;
  late TextEditingController _option2Controller;
  late TextEditingController _option3Controller;
  late TextEditingController _option4Controller;
  late TextEditingController _correctAnswerController;

  @override
  void initState() {
    super.initState();
    _questionTextController =
        TextEditingController(text: widget.question?.question_text ?? '');
    _option1Controller =
        TextEditingController(text: widget.question?.option1 ?? '');
    _option2Controller =
        TextEditingController(text: widget.question?.option2 ?? '');
    _option3Controller =
        TextEditingController(text: widget.question?.option3 ?? '');
    _option4Controller =
        TextEditingController(text: widget.question?.option4 ?? '');
    _correctAnswerController =
        TextEditingController(text: widget.question?.correct_answer ?? '');
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _correctAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _questionTextController,
              decoration: InputDecoration(labelText: 'Question Text'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the question text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _option1Controller,
              decoration: InputDecoration(labelText: 'Option 1'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option 1';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _option2Controller,
              decoration: InputDecoration(labelText: 'Option 2'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option 2';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _option3Controller,
              decoration: InputDecoration(labelText: 'Option 3'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option 3';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _option4Controller,
              decoration: InputDecoration(labelText: 'Option 4'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option 4';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _correctAnswerController,
              decoration: InputDecoration(labelText: 'Correct Answer'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the correct answer';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Questions newQuestion = Questions(
                    id: widget.question?.id ?? 0,
                    question_text: _questionTextController.text,
                    option1: _option1Controller.text,
                    option2: _option2Controller.text,
                    option3: _option3Controller.text,
                    option4: _option4Controller.text,
                    correct_answer: _correctAnswerController.text,
                    quizId: widget.quizId,
                  );
                  widget.onSave(newQuestion);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
