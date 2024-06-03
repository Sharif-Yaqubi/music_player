import 'package:flutter/foundation.dart';
import '../model/favorite.dart';
import 'databaseHelper.dart';

class FavoriteProvider with ChangeNotifier {
  List<FavoriteSong> _favorites = [];
  final DBHelper _dbHelper = DBHelper();

  List<FavoriteSong> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    notifyListeners();
  }

  void addFavorite(FavoriteSong favoriteSong) async {
    await _dbHelper.insertFavorite(favoriteSong);
    _favorites.add(favoriteSong);
    notifyListeners();
  }

  void removeFavorite(String id) async {
    await _dbHelper.deleteFavorite(id);
    _favorites.removeWhere((favorite) => favorite.id == id);
    notifyListeners();
  }
}
