import 'package:flutter/material.dart';
import 'package:music_player/provider/favoriteSongProvider.dart';
import 'package:music_player/provider/search_provider.dart';
import 'package:provider/provider.dart';

import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
