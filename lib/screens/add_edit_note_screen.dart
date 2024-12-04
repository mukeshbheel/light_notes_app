import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_local_database/controller/notes_controller.dart';
import 'package:notes_app_local_database/models/data_model.dart';
import 'package:notes_app_local_database/services/db_services.dart';
import 'package:notes_app_local_database/utils/global.dart';

class AddEditNoteScreen extends StatefulWidget {
  NoteModel? noteModel;

  AddEditNoteScreen({this.noteModel});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  String? colorString;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.noteModel != null) {
      colorString = widget.noteModel!.colorString;
      titleController.text = widget.noteModel!.title;
      contentController.text = widget.noteModel!.content;
    } else {
      colorString = getRandomColorString();
    }
    super.initState();
  }

  void createRandomColor() {
    setState(() {
      colorString = getRandomColorString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:
        //     colorString != null ? colorFromString(colorString!) : Colors.white,
        centerTitle: true,
        title: Text(
          widget.noteModel == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 18,),
        ),
        // iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if(widget.noteModel != null)
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.black87,),
            onPressed: () async {
              showDialog(context: context, builder: (context)=>AlertDialog(
                contentPadding: const EdgeInsets.all(5),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                content: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorString != null
                              ? colorFromString(colorString!)
                              : Colors.white,
                          Colors.black87
                        ]),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(1, 5))
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Delete Note', style: TextStyle(color: Colors.white, fontSize: 20),),
                      SizedBox(height: 20,),
                      Text('Are you sure you want to delete this note?', style: TextStyle(color: Colors.white, fontSize: 16),),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            DbServices().deleteNote(widget.noteModel!);
                            Get.find<NotesController>().getAllNotes();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    // colorString != null
                                    //     ? colorFromString(colorString!)
                                    //     : Colors.white,
                                    Colors.black87,
                                    Colors.black87,
                                  ]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(1, 5))
                              ],
                            ),
                            child: const Center(child: Text("Yes", style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    // colorString != null
                                    //     ? colorFromString(colorString!)
                                    //     : Colors.white,
                                    Colors.black87,
                                    Colors.black87,
                                  ]),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(1, 5))
                              ],
                            ),
                            child: const Center(child: Text("No", style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.save, size: 20, color: Colors.black87,),
            onPressed: () async {
              // Save note functionality
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Add Title",
                      style: TextStyle(color: Colors.white),
                    )));
                return;
              }
              if (contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Add content",
                      style: TextStyle(color: Colors.white),
                    )));
                return;
              }

              if (widget.noteModel == null) {
                NoteModel note = NoteModel(
                    title: titleController.text,
                    content: contentController.text,
                    colorString: colorString!);
                await DbServices().addNote(note);
              } else {
                NoteModel note = NoteModel(
                    id: widget.noteModel!.id,
                    title: titleController.text,
                    content: contentController.text,
                    colorString: colorString!);
                await DbServices().updateNote(note);
              }

              Get.find<NotesController>().getAllNotes();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorString != null
                    ? colorFromString(colorString!)
                    : Colors.white,
                Colors.black87
              ]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(1, 5))
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: 'Write your note here...',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: createRandomColor,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // colorString != null
                        //     ? colorFromString(colorString!)
                        //     : Colors.white,
                        Colors.black,
                        Colors.black38,
                      ]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 1,
                        spreadRadius: 2,
                        offset: Offset(1, 5))
                  ],
                ),
                child: const Center(child: Text("Change Color", style: TextStyle(color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
