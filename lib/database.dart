import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Añadido para importar el paquete 'path'.
import 'dart:async';

class DatabaseHelper {
  late Database _db;

  Future<void> initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'namer.db'), // Cambiado el nombre del archivo de la base de datos.
      version: 1,
      onCreate: (Database db, int version) {
        db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first TEXT
          )
        ''');
      },
    );
  }
}
