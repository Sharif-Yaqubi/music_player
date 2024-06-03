import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/favorite.dart';

class DatabaseHelper {
  static const String _dbName = 'favorite_songs.db';
  static const String _tableName = 'favorite_songs';

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            url TEXT,
            image TEXT,
            name TEXT,
            artist TEXT
          )
          ''');
  }

  Future<int> insertFavoriteSong(FavoriteSong song) async {
    final db = await database;
    return await db!.insert(_tableName, song.toJson());
  }

  Future<List<FavoriteSong>> getFavoriteSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(_tableName);
    return List.generate(maps.length, (i) {
      return FavoriteSong.fromJson(maps[i]);
    });
  }

  Future<int> deleteFavoriteSong(String url) async {
    final db = await database;
    return await db!.delete(_tableName, where: 'url =?', whereArgs: [url]);
  }
}
