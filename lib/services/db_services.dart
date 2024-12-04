import 'package:notes_app_local_database/models/data_model.dart';
import 'package:notes_app_local_database/utils/db_helper.dart';

class DbServices{
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    await DbHelper.init();
    List<Map<String, dynamic>> notes = await DbHelper.query(NoteModel.tableName);
    return notes;
  }

  Future<bool> addNote(NoteModel model) async {
    await DbHelper.init();
    int res = await DbHelper.insert(NoteModel.tableName, model);
    return res > 0;
  }

  Future<bool> updateNote(NoteModel model) async {
    await DbHelper.init();
    int res = await DbHelper.update(NoteModel.tableName, model);
    return res > 0;
  }

  Future<bool> deleteNote(NoteModel model) async {
    await DbHelper.init();
    int res = await DbHelper.delete(NoteModel.tableName, model);
    return res > 0;
  }
}