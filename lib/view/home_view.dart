import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var hive = await Hive.openBox("Mehroz");
            hive.put("name", "Mehrooz Hassan");
            hive.put('age', 23);
            hive.put("details", {
              "name": "Mehroz Hassan",
              "marks": "${3.5}cgpa"
            });
            if (kDebugMode) {
              print(hive.get("name"));
              print(hive.get('age'));
              print(hive.get("details")['marks']);
            }
          },
      child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Title(color: Colors.white,
            child: const Text("Hive Practice")),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('Mehroz'),
              builder: (context, snapshot){
                return  ListTile(
                  title: Text(snapshot.data?.get('details')['name']),
                  subtitle: Text(snapshot.data?.get('details')['marks']),
                );
              })
        ],
      ),
    );
  }
}
