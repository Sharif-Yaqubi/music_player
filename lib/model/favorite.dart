import 'package:music_player/model/song.dart';
import 'package:uuid/uuid.dart';

class FavoriteSong {
  final String url;
  final String image;
  final String name;
  final String artist;
  final String id;
  final int songId;
  final String time;

  FavoriteSong({
    required this.url,
    required this.image,
    required this.name,
    required this.artist,
    required this.songId,
    required this.time,
  }) : id = const Uuid().v4();

  factory FavoriteSong.fromJson(Map<String, dynamic> json) {
    return FavoriteSong(
      url: json['url'],
      image: json['image'],
      name: json['name'],
      artist: json['artist'],
      songId: json['songId'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'image': image,
      'name': name,
      'artist': artist,
      'songId': songId,
      'time': time,
    };
  }

  factory FavoriteSong.fromSong(Map<String, dynamic> json) {
    return FavoriteSong(
      url: json['url'],
      image: json['image'],
      name: json['name'],
      artist: json['artist'],
      songId: json['songId'],
      time: json['time'],
    );
  }
}
