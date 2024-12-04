import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notes_app_local_database/controller/notes_controller.dart';
import 'package:notes_app_local_database/models/data_model.dart';
import 'package:notes_app_local_database/screens/add_edit_note_screen.dart';
import 'package:notes_app_local_database/services/db_services.dart';
import 'package:notes_app_local_database/utils/global.dart';

class NotesHomePage extends StatelessWidget {

  NotesController notesController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black,),
            onPressed: () {
              // Search functionality
              notesController.getAllNotes();
            },
          ),
        ],
      ),
      body: Obx(()=>Column(
        children: [
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 8, // Vertical spacing
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(10),
              itemCount: notesController.notes.length, // Replace with the length of your notes list
              itemBuilder: (context, index) {
                return LongPressDraggable<NoteModel>(

                  data: notesController.notes[index],
                  onDragStarted: (){
                    notesController.showDragArea.value = true;
                  },
                  onDragCompleted: (){
                    notesController.showDragArea.value = false;
                  },
                  onDraggableCanceled: (v, o){
                    notesController.showDragArea.value = false;
                  },
                  feedback: Material(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [colorFromString(notesController.notes[index].colorString), Colors.black87],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(1, 5)
                            )
                          ]
                      ),
                      child: Center(child: Text(notesController.notes[index].title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                    ),
                  ),
                  childWhenDragging: const SizedBox(),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditNoteScreen(noteModel: notesController.notes[index],)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [colorFromString(notesController.notes[index].colorString), Colors.black87],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(1, 5)
                            )
                          ]
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(notesController.notes[index].title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        subtitle: Text(notesController.notes[index].content, style: const TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if(notesController.showDragArea.value)
            DragTarget<NoteModel>(
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  ) {
                return Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.black,
                      ]
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2)
                      )
                    ]
                  ),
                  height: 100.0,
                  width: 100.0,
                  child: const Center(
                    child: Icon(Icons.delete, size: 30, color: Colors.white,),
                  ),
                );
              },
              onAcceptWithDetails: (DragTargetDetails<NoteModel> details) {
                log(details.data.title);
                DbServices().deleteNote(details.data);
                notesController.getAllNotes();
                // setState(() {
                //   acceptedData += details.data;
                // });
              },
            ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          // Navigate to Add Note Screen
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditNoteScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}