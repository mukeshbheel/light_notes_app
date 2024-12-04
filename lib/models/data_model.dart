import 'package:notes_app_local_database/models/model.dart';

class NoteModel extends Model{

  static String tableName = "Notes";

  @override
  int? id;
  String title;
  String content;
  String colorString;

  // String colorCode;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.colorString,
  });

  static NoteModel fromMap(Map<String, dynamic> map){
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      colorString: map['colorString'],
    );
  }


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title":title,
      "content":content,
      "colorString":colorString,
    };
    if(id != null){
      map["id"] = id;
    }
    return map;
  }
}
