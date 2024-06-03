import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:music_player/provider/search_provider.dart';
import 'package:music_player/screen/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
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
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.account_circle,
            color: kPrimaryColor,
            size: 40,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
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
                )),
          )
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
    final songProvider = Provider.of<SearchProvider>(context);
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
              onSubmitted: (query) {
                songProvider.searchSongs(query);
              },
              textController: searchController,
              onSuffixTap: () {
                setState(() {
                  searchController.clear();
                  songProvider.searchSongs('');
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 10),
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
                    },
                  ),
                ),
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
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: songProvider.songs.length,
              itemBuilder: (context, index) =>
                  buildSonglistItem(song: songProvider.songs, index: index),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSonglistItem({required List<Song> song, required int index}) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongScreen(
              song: song,
              initialIndex: index,
            ),
          ),
        );
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(song[index].songName),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              song[index].time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(song[index].artist),
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(song[index].image),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      trailing: const SizedBox(
        width: 50,
        child: LikeButton(
          animationDuration: Duration(milliseconds: 1000),
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
