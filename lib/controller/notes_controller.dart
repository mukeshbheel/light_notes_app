import 'package:get/get.dart';
import 'package:notes_app_local_database/models/data_model.dart';
import 'package:notes_app_local_database/services/db_services.dart';

class NotesController extends GetxController{
  DbServices db = DbServices();
  RxList<NoteModel> notes = <NoteModel>[].obs;
  RxBool showDragArea = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getAllNotes();
    super.onInit();
  }

  void getAllNotes() async {
    notes.clear();
    List<Map<String, dynamic>> data  = await db.getAllNotes();
    for(Map<String, dynamic> item in data){
      notes.add(NoteModel.fromMap(item));
    }
  }

}