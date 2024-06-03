import 'package:flutter/material.dart';
import '../model/favorite.dart';
import 'databaseHelper.dart';

class FavoriteSongProvider with ChangeNotifier {
  List<FavoriteSong> _favoriteSongs = [];
  bool _favorite = false;
  bool get favorite => _favorite;

  List<FavoriteSong> get favoriteSongs => _favoriteSongs;

  Future<void> initFavoriteSongs() async {
    final databaseHelper = DatabaseHelper();
    final favoriteSongs = await databaseHelper.getFavoriteSongs();
    _favoriteSongs = favoriteSongs;
    notifyListeners();
  }

  Future<void> addFavoriteSong(FavoriteSong song) async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.insertFavoriteSong(song);
    _favoriteSongs.add(song);
    _favorite = true;
    notifyListeners();
  }

  Future<void> removeFavoriteSong(String url) async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.deleteFavoriteSong(url);
    _favoriteSongs.removeWhere((song) => song.url == url);
    _favorite = false;
    notifyListeners();
  }
}
