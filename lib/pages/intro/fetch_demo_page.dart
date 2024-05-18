import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simaskuli/models/user.dart';

Future<List<User>> getUser() async {
  //TODO: Replace the endpoint API (https://simaskuli-api.vercel.app/api/api/XXXXXXXX)
  const endpoint = 'https://simaskuli-api.vercel.app/api/api/users';

  final res = await http.get(Uri.parse(endpoint));
  if (res.statusCode == 200) {
    var data = jsonDecode(res.body); //Response body dari API
    var parsed = data.cast<Map<String, dynamic>>(); //Parsing data JSON
    return parsed
        .map<User>((json) => User.fromJson(json))
        .toList(); //Mengembalikan data dengan parse dari JSON ke List Model
  } else {
    throw Exception('Failed');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(snapshot.data![index].email),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
