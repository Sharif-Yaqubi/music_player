import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/favorite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            url TEXT,
            image TEXT,
            name TEXT,
            artist TEXT,
            songId INTEGER,
            time TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(FavoriteSong favoriteSong) async {
    final db = await database;
    await db.insert('favorites', favoriteSong.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FavoriteSong>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return FavoriteSong.fromJson(maps[i]);
    });
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
