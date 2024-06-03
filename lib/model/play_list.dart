// ignore_for_file: public_member_api_docs, sort_constructors_first
class Playlist {
  final String playlistName;
  final String image;
  final int? id;
  Playlist({
    required this.playlistName,
    required this.image,
    this.id,
  });
}

List<Playlist> playlists = [
  Playlist(
    id: 1,
    playlistName: 'Party',
    image: "assets/images/party.jpg",
  ),
  Playlist(
    id: 2,
    playlistName: 'Peace',
    image: "assets/images/meditation.jpg",
  ),
  Playlist(
    id: 3,
    playlistName: 'Flutter Time',
    image: "assets/images/colors.jpg",
  ),
  Playlist(
    id: 4,
    playlistName: 'Romance',
    image: "assets/images/love.jpg",
  ),
];
