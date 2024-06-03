import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/favoriteSongProvider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favoriteSongProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: favoriteSongProvider.favorites.isEmpty
          ? const Center(
              child: Text('No favorite songs added.'),
            )
          : ListView.builder(
              itemCount: favoriteSongProvider.favorites.length,
              itemBuilder: (context, index) {
                final favorite = favoriteSongProvider.favorites[index];
                return ListTile(
                  leading: Image.asset(
                    favorite.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, size: 50);
                    },
                  ),
                  title: Text(favorite.name),
                  subtitle: Text(favorite.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        favoriteSongProvider.removeFavorite(favorite.id),
                  ),
                );
              },
            ),
    );
  }
}
