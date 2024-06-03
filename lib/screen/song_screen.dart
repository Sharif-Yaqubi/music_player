import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:music_player/model/song.dart';
import 'package:provider/provider.dart';
import '../constants/color.dart';
import '../provider/favoriteSongProvider.dart';

class SongScreen extends StatefulWidget {
  final List<Song> song;
  final int initialIndex;
  const SongScreen({
    super.key,
    required this.song,
    required this.initialIndex,
  });

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration? duration;
  Duration durations = Duration.zero;
  Duration position = Duration.zero;
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        durations = newDuration;
      });
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    _playSong();
  }

  void _playSong() async {
    await _audioPlayer.setSource(AssetSource(widget.song[currentIndex].url));
    duration = await _audioPlayer.getDuration();
  }

  void playNext() {
    if (currentIndex < widget.song.length - 1) {
      setState(() {
        currentIndex++;
      });
      _playSong();
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _playSong();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final favoriteSongProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.grey,
        ),
        title: const Text(
          'Playing Now ',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.song[currentIndex].image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    widget.song[currentIndex].songName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  const SizedBox(
                    width: 50,
                    child: LikeButton(
                      animationDuration: Duration(milliseconds: 1000),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.song[currentIndex].artist,
                style: const TextStyle(
                    color: kLightColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              width: double.infinity,
              child: Slider.adaptive(
                min: 0,
                max: durations.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                  await _audioPlayer.resume();
                },
                activeColor: Colors.pink,
                inactiveColor: Colors.grey.withOpacity(0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    formatTime(position),
                    style: const TextStyle(
                        color: kLightColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    formatTime(durations - position),
                    style: const TextStyle(
                        color: kLightColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.pink.withOpacity(0.5),
                      size: 0.09 * size.width,
                    ),
                  ),
                  GestureDetector(
                    onTap: playPrevious,
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.pink,
                      size: 0.12 * size.width,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await _audioPlayer.pause();
                      } else {
                        await _audioPlayer.resume();
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_circle_outline,
                      color: Colors.pink,
                      size: 0.18 * size.width,
                    ),
                  ),
                  GestureDetector(
                    onTap: playNext,
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.pink,
                      size: 0.12 * size.width,
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.swap_horiz,
                      color: Colors.pink.withOpacity(0.5),
                      size: 0.09 * size.width,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (durations.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
