import 'package:flutter/material.dart';
import 'package:flutter_local_storage_practice/models/notes_model.dart';
import 'package:flutter_local_storage_practice/view/home_view.dart';
import 'package:flutter_local_storage_practice/view/notes_view.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>("notes");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hive',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: NotesView(),
    );
  }
}