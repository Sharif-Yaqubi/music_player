// ignore_for_file: public_member_api_docs, sort_constructors_first

class Song {
  final String songName;
  final String artist;
  final String image;
  final int id;
  final String time;
  final String url;

  Song({
    required this.songName,
    required this.artist,
    required this.image,
    required this.id,
    required this.time,
    required this.url,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songName: json['songName'],
      artist: json['artist'],
      image: json['image'],
      id: json['id'],
      time: json['time'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songName': songName,
      'artist': artist,
      'image': image,
      'id': id,
      'time': time,
      'url': url,
    };
  }
}

List<Song> songs = [];
