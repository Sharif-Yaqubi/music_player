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
    final favoriteSongProvider = Provider.of<FavoriteSongProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      body: ListView.builder(
        itemCount: favoriteSongProvider.favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongProvider.favoriteSongs[index];
          return ListTile(
            leading: Image.asset(song.image,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(song.name),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  favoriteSongProvider.removeFavoriteSong(song.url),
            ),
          );
        },
      ),
    );
  }
}
