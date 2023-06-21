import 'package:notes/database/db_support.dart';
import 'package:notes/database/notes_class.dart';

class NotesDao {
  Future<List<Notes>> allNotes() async {
    var db = await DBSupport.accesdb();
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM notedb");
    return List.generate(maps.length, (index) {
      var ind = maps[index];
      return Notes(ind["id"], ind["title"], ind["text"], ind["date"]);
    });
  }

  Future<void> addNote(String title, String text, String date) async {
    var db = await DBSupport.accesdb();
    var infos = <String, dynamic>{};
    infos["title"] = title;
    infos["text"] = text;
    infos["date"] = date;

    await db.insert("notedb", infos);
  }

  Future<void> updateNote(int id, String title, String text, String date) async {
    var db = await DBSupport.accesdb();
    var infos = <String, dynamic>{};
    infos["title"] = title;
    infos["text"] = text;
    infos["date"] = date;

    await db.update("notedb", infos, where: "id=?", whereArgs: [id]);
  }

  Future<void> deleteNote(int id) async {
    var db = await DBSupport.accesdb();
    await db.delete("notedb", where: "id=?", whereArgs: [id]);
  }
}
