import 'package:flutter_local_storage_practice/models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes{

  static Box<NotesModel> getBox() => Hive.box<NotesModel>('notes');

}