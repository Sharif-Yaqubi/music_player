import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/provider/favoriteSongProvider.dart';
import 'package:music_player/screen/favorite_screen.dart';
import 'package:provider/provider.dart';
import '../constants/color.dart';
import '../model/play_list.dart';
import '../model/song.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'song_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  final searchController = TextEditingController();
  List<Song> filteredSongs = [];

  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
    filteredSongs = songs;
    searchController.addListener(() {
      filterSongs();
    });
  }

  void filterSongs() {
    setState(() {
      filteredSongs = songs.where((song) {
        final query = searchController.text.toLowerCase();
        return song.songName.toLowerCase().contains(query) ||
            song.artist.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        leading: const Icon(
          Icons.account_circle,
          color: kPrimaryColor,
          size: 40,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite,
                size: 40,
                color: Colors.pink,
              ))
        ],
      ),
      body: Column(
        children: [
          _buildPlaylistAndSongs(size),
        ],
      ),
    );
  }

  Widget _buildPlaylistAndSongs(Size size) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            child: AnimSearchBar(
              width: 400,
              color: Colors.pink,
              rtl: true,
              searchIconColor: Colors.white,
              textFieldIconColor: Colors.white,
              onSubmitted: (p0) {},
              textController: searchController,
              onSuffixTap: () {
                setState(() {
                  searchController.clear();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'Recent Play list',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          playlists.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CarouselSlider.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index, realIndex) {
                    final playlist = playlists[index];
                    return buildImage(
                        name: playlist.playlistName,
                        index: index,
                        image: playlist.image);
                  },
                  options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      })),
          const SizedBox(height: 10.0),
          Center(child: buildIndicator()),
          const SizedBox(height: 10.0),
          const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'list of Song',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: songs.length,
              itemBuilder: (context, index) => buildSonglistItem(
                image: songs[index].image,
                title: songs[index].songName,
                subtitle: songs[index].artist,
                time: songs[index].time,
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem({
    required String title,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Expanded(child: Container(height: 0)),
            Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSonglistItem({
    required String image,
    required String title,
    required String subtitle,
    required String time,
    required int index,
  }) {
    final favoriteSongProvider = Provider.of<FavoriteSongProvider>(context);
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongScreen(song: filteredSongs[index]),
          ),
        );
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(subtitle),
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          // favoriteSongProvider.addFavoriteSong(filteredSongs[index]);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(favoriteSongProvider.favorite
          //         ? 'Removed from favorites!'
          //         : 'Added to favorites!'),
          //   ),
          // );
        },
        icon: Icon(
          Icons.favorite,
          size: 30,
          color: favoriteSongProvider.favorite ? Colors.pink : Colors.grey,
        ),
      ),
    );
  }

  Widget buildImage({
    required String image,
    required int index,
    required String name,
  }) =>
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.only(left: 10.0),
              margin: const EdgeInsets.only(top: 170.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]));
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: playlists.length,
        effect: const WormEffect(
          activeDotColor: Colors.pink,
          dotColor: Colors.grey,
          dotHeight: 15,
          dotWidth: 15,
          radius: 30,
        ),
      );
}
