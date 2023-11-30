import 'package:english_words/english_words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static initDB() async {
    String path = join(await getDatabasesPath(), 'namer.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first TEXT,
          second TEXT
        )
      ''');
    });
  }

  static Future<void> insertFavorite(WordPair pair) async {
    final Database db = await database;
    await db.insert(
      'favorites',
      {'first': pair.first, 'second': pair.second},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<WordPair>> getFavorites() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return WordPair(
        maps[i]['first'],
        maps[i]['second'],
      );
    });
  }

  static Future<void> deleteFavorite(WordPair pair) async {
    final Database db = await database;
    await db.delete(
      'favorites',
      where: 'first = ? AND second = ?',
      whereArgs: [pair.first, pair.second],
    );
  }

  static Future<void> printFavorites() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('favorites');

      if (maps.isNotEmpty) {
        print('Printing favorites:');
        for (var map in maps) {
          print(
              'ID: ${map['id']}, First: ${map['first']}, Second: ${map['second']}');
        }
      } else {
        print('No favorites found.');
      }
    } catch (e) {
      print('Error al imprimir favoritos: $e');
    }
  }
}
