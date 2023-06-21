import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBSupport {
  static const String dbname = "note_database.sqlite";

  static Future<Database> accesdb() async {
    String dpPath = join(await getDatabasesPath(), dbname);

    if (await databaseExists(dpPath)) {
      //Veritabanı var mı yok mu kontrolü
      print("Database current.");
    } else {
      //assetten veritabanının alınması
      ByteData data = await rootBundle.load("Database/$dbname");
      //Veritabanının kopyalama için byte dönüşümü
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //Veritabanının kopyalanması.
      await File(dpPath).writeAsBytes(bytes, flush: true);
      print("Copied Database");
    }
    //Veritabanını açıyoruz.
    Database database = await openDatabase(
      dpPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE notedb (id INTEGER PRIMARY KEY, title TEXT, text TEXT,date TEXT)');
      },
    );
    return database;
  }
}
