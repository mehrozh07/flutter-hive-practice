import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_storage_practice/boxes/boxes.dart';
import 'package:flutter_local_storage_practice/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class NotesView extends StatelessWidget {
   NotesView({Key? key}) : super(key: key);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: Colors.white,
            child: const Text("My Notes")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
          onPressed: (){
            _addNotesDialogue(context);
          },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getBox().listenable(),
          builder: (context, box,__){
        return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              var data = box.values.cast<NotesModel>().toList().reversed.toList();
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              title: Title(
                  color: Colors.white,
                  child: Text(data[index].title)),
              subtitle: Text(data[index].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      padding: EdgeInsets.zero,
                    ),
                      onPressed: (){
                      _editNotesDialogue(context, data[index],
                          data[index].title.toString(),
                          data[index].description.toString());
                      },
                      child: const Icon(Icons.edit),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        iconColor: Colors.red,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: (){
                        deleteNote(data[index]);
                      },
                      child: const Icon(Icons.delete)),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
  void deleteNote(NotesModel notesModel){
    notesModel.delete();
  }
   Future<void> _editNotesDialogue(context, NotesModel notesModel, title, description) async{
    titleController.text = title;
    descriptionController.text = description;

     await showDialog<void>(
       context: context,
       barrierDismissible: false,
       // false = user must tap button, true = tap outside dialog
       builder: (BuildContext dialogContext) {
         return AlertDialog(
           title: const Text('Edit Notes'),
           content: SingleChildScrollView(
             child: Column(
               children: [
                 TextFormField(
                   controller: titleController,
                   decoration: const InputDecoration(
                     hintText: "title",
                   ),
                 ),
                 TextFormField(
                   controller: descriptionController,
                   decoration: const InputDecoration(
                     hintText: "description",
                   ),
                 ),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               child: const Text('Cancel'),
               onPressed: () {
                 Navigator.of(dialogContext).pop(); // Dismiss alert dialog
               },
             ),
             TextButton(
               child: const Text('Edit'),
               onPressed: () {
                 notesModel.title = titleController.text.toString();
                 notesModel.description = descriptionController.text.toString();
                 notesModel.save();
                 titleController.clear();
                 descriptionController.clear();
                 Navigator.of(dialogContext).pop(); // Dismiss alert dialog
               },
             ),
           ],
         );
       },
     );
   }
  Future<void> _addNotesDialogue(context) async{
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Notes'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "title",
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "description",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final data = NotesModel(title: titleController.text, description: descriptionController.text);
                final box = Boxes.getBox();
                box.add(data);
                data.save();
                titleController.clear();
                descriptionController.clear();
                if (kDebugMode) {
                  print(data.title);
                  print(data.description);
                }
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
