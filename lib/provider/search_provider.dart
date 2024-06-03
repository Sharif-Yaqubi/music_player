import 'package:flutter/material.dart';

import '../model/song.dart';

class SearchProvider with ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  List<Song> get songs => _filteredSongs.isEmpty ? _songs : _filteredSongs;
  SearchProvider() {
    _loadSongs();
  }
  void searchSongs(String query) {
    if (query.isEmpty) {
      _filteredSongs = [];
    } else {
      _filteredSongs = _songs.where((song) {
        return song.songName.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void _loadSongs() {
    _songs = [
      Song(
        id: 1,
        songName: 'beautiful song.',
        url: "songs/beautiful-song.mp3",
        artist: 'DubVision',
        time: '1:03',
        image: 'assets/images/eminem.jpg',
      ),
      Song(
        id: 2,
        songName: 'canyon song',
        url: "songs/canyon-song.mp3",
        artist: 'Disclosure',
        time: '1:43',
        image: 'assets/images/bellyache.jpeg',
      ),
      Song(
        id: 3,
        songName: 'sad piano song',
        url: "songs/climax-epic-sad-piano-song.mp3",
        artist: 'Ziv Zaifman',
        time: '2:40',
        image: 'assets/images/billiebadguy.jpg',
      ),
      Song(
        id: 4,
        songName: 'funny song',
        url: "songs/funny-song.mp3",
        artist: 'Paperwhite',
        time: '2:24',
        image: 'assets/images/billieellish.jpg',
      ),
      Song(
        id: 5,
        songName: 'happy song',
        url: "songs/happy-song.mp3",
        artist: 'Demi',
        time: '2:14',
        image: 'assets/images/dualipa.jpg',
      ),
      Song(
          id: 6,
          songName: 'love song',
          url: "songs/heartbreak-piano-love-song.mp3",
          artist: 'Austin',
          time: '3:06',
          image: 'assets/images/godzillaeminem.png'),
      Song(
        id: 7,
        songName: 'lofi song chinese',
        url: "songs/lofi-song-chinese-guangzuo-zingshen-by-lofium.mp3",
        artist: 'guangzuo zingshen',
        time: '2:58',
        image: 'assets/images/meditation.jpg',
      ),
      Song(
        id: 8,
        songName: 'lofi song',
        url: "songs/lofi-song-elegance-by-lofium.mp3",
        artist: 'Peter',
        time: '3:02',
        image: 'assets/images/party.jpg',
      ),
      Song(
          id: 9,
          songName: 'lofi song',
          url: "songs/lofi-song-nature-by-lofium.mp3",
          artist: 'lofium',
          time: '2:00',
          image: 'assets/images/notimetodiebe.jpg'),
      Song(
          id: 10,
          songName: 'lullaby-song.',
          url: "songs/lullaby-song.mp3",
          artist: 'Peter',
          time: '2:43',
          image: 'assets/images/relax.jpg'),
      Song(
        id: 11,
        songName: 'sad',
        url: "songs/sad-piano-strings-song-rain-cry-sorrow.mp3",
        artist: 'Peter',
        time: '1:46',
        image: 'assets/images/dualipa.jpg',
      ),
      Song(
        id: 12,
        songName: 'romantic-song',
        url: "songs/teri-ye-adaa-romantic-song.mp3",
        artist: 'teri-ye-adaa',
        time: '1:08',
        image: 'assets/images/godzillaeminem.png',
      ),
    ];
    notifyListeners();
  }
}
