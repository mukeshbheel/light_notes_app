import 'package:flutter/material.dart';
import 'package:notes_app_local_database/screens/notes_home_page.dart';

void main() {
  runApp(NoteTakingApp());
}

class NoteTakingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: NotesHomePage(),
    );
  }
}

