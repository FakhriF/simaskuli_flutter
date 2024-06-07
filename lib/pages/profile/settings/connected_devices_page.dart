import 'package:flutter/material.dart';
import 'package:simaskuli/controller/user_auth_controller.dart';

class ConnectedDevicesPage extends StatefulWidget {
  const ConnectedDevicesPage({super.key});

  @override
  State<ConnectedDevicesPage> createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  late Future session;

  @override
  void initState() {
    session = getAllSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connected Devices"),
      ),
      body: FutureBuilder(
        future: session,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.data![index]["user_agent"].toString() !=
                              "")
                            Text(snapshot.data![index]["user_agent"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          if (snapshot.data![index]["user_agent"].toString() ==
                              "")
                            Text("Android Device",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(snapshot.data![index]["ip_address"]),
                          Text(snapshot.data![index]["last_activity_parse"]),
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
