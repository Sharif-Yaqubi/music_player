import 'package:uuid/uuid.dart';

class FavoriteSong {
  final String url;
  final String image;
  final String name;
  final String artist;
  final String id;

  FavoriteSong({
    required this.url,
    required this.image,
    required this.name,
    required this.artist,
  }) : id = const Uuid().v4();

  factory FavoriteSong.fromJson(Map<String, dynamic> json) {
    return FavoriteSong(
      url: json['url'],
      image: json['image'],
      name: json['name'],
      artist: json['artist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'image': image,
      'name': name,
      'artist': artist,
    };
  }
}
