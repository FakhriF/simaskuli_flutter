import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  shrinkWrap: true,
                  children: [

                    ListTile(
                      onTap: () => {

                        debugPrint("You clicked on this thread!"),
                      },
                      leading: Icon(Icons.people),
                      title: const Text('Name'),
                      subtitle: Text(
                        'By {name}, MMM dd, yyyy',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.blue, size: 20),
                        onPressed: () => {
                          debugPrint("You liked this Thread!"),
                        },
                      ),
                    ),
                    Divider(),

                    ListTile(
                      onTap: () => {

                        debugPrint("You clicked on this thread!"),
                      },
                      leading: Icon(Icons.people),
                      title: const Text('Name'),
                      subtitle: Text(
                        'By {name}, MMM dd, yyyy',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.blue, size: 20),
                        onPressed: () => {
                          debugPrint("You liked this Thread!"),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )

          ]



        ),
        // child: Center(
        //   child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         Text("Test")
        //       ]
        //
        //   ),
        // ),
      ),

    );
  }
}