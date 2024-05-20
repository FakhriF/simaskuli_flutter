import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  static const List<String> title = ['Lorem', 'Ipsum', 'dolor']; // Temp Data
  static const List<String> name = ['Albert', 'Bekky', 'Clarisse']; // Temp Data



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: const Text(
                "Forum",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          debugPrint("You clicked on this thread!");
                        },
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          '${title[index]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'By ${name[index]}, MMM dd, yyyy',
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up, color: Colors.blue, size: 20),
                              onPressed: () {
                                debugPrint("You liked this Thread!");
                              },
                            ),
                            Text('Likes', style: TextStyle(color: Colors.blue)) , // Example text
                          ],
                        ),

                      ),
                    ),
                  );
                },
              ), 

            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Create New Thread button pressed!");
                },
                child: Text("Create New Thread"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}