
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'MusicModel.dart';
import 'color.dart';
import 'package:audio_service/audio_service.dart';


class MusicPlayerScreenController extends StatefulWidget {
  final List<MusicModel> musicList;
  final int initialIndex;

  const MusicPlayerScreenController({
    Key? key,
    required this.musicList,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _MusicPlayerScreenControllerState createState() =>
      _MusicPlayerScreenControllerState();
}

class _MusicPlayerScreenControllerState
    extends State<MusicPlayerScreenController> {
  late AudioPlayer audioPlayer;
  int currentIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    _isSongLiked(widget.musicList[currentIndex].songName);
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await audioPlayer.setUrl(widget.musicList[currentIndex].songURL);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayersScreen(
      musicList: widget.musicList,
      initialIndex: widget.initialIndex,
      audioPlayer: audioPlayer,
      currentIndex: currentIndex,
      isFavorite: isFavorite,
      onIndexChanged: (int newIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      },
      onFavoritePressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
        if (isFavorite) {
          _addSongToFavorites();
        } else {
          removeLikedSong(widget.musicList[currentIndex].songName);
        }
      },
    );
  }

  Future<void> _isSongLiked(String songName) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final CollectionReference likedSongsCollection = FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('liked_songs');

      final QuerySnapshot querySnapshot =
      await likedSongsCollection.where('song', isEqualTo: songName).get();
      setState(() {
        isFavorite = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  Future<void> _addSongToFavorites() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final Directory likedSongsDirectory =
      Directory('${directory.path}/Liked Songs');
      if (!(await likedSongsDirectory.exists())) {
        await likedSongsDirectory.create();
      }

      final MusicModel currentSong = widget.musicList[currentIndex];
      final String fileName = '${currentSong.songName}.mp3';
      final File songFile = File('${likedSongsDirectory.path}/$fileName');

      final HttpClient httpClient = HttpClient();
      final HttpClientRequest request =
      await httpClient.getUrl(Uri.parse(currentSong.songURL));
      final HttpClientResponse response = await request.close();
      final Uint8List bytes =
      await consolidateHttpClientResponseBytes(response);
      await songFile.writeAsBytes(bytes);

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('liked_songs/$fileName');
      await storageRef.putFile(songFile);

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('user');
        final CollectionReference likedSongsCollection =
        userCollection.doc(user.uid).collection('liked_songs');
        await likedSongsCollection.add({
          'song': currentSong.songName,
          'url': await storageRef.getDownloadURL(),
          'singer': currentSong.singerName,
          'genre': currentSong.category,
          'image': currentSong.image,
          'lyrics': currentSong.lyrics,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Song added to Liked Songs!'),
        ));
      }
    } catch (e) {
      print('Error adding song to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add song to Liked Songs'),
      ));
    }
  }

  Future<void> removeLikedSong(String songName) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('user');
        final CollectionReference likedSongsCollection =
        userCollection.doc(user.uid).collection('liked_songs');

        final QuerySnapshot querySnapshot =
        await likedSongsCollection.where('song', isEqualTo: songName).get();
        final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

        if (documents.isNotEmpty) {
          final String storageUrl = documents.first.get('url');
          await documents.first.reference.delete();
          final Reference storageRef =
          FirebaseStorage.instance.refFromURL(storageUrl);
          await storageRef.delete();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Song removed from Liked Songs!'),
          ));
        }
      }
    } catch (e) {
      print('Error removing liked song: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to remove song from Liked Songs'),
      ));
    }
  }
}

class MusicPlayersScreen extends StatefulWidget {
  final List<MusicModel> musicList;
  final int initialIndex;
  final AudioPlayer audioPlayer;
  final int currentIndex;
  final bool isFavorite;
  final Function(int) onIndexChanged;
  final VoidCallback onFavoritePressed;



  const MusicPlayersScreen({
    Key? key,
    required this.musicList,
    required this.initialIndex,
    required this.audioPlayer,
    required this.currentIndex,
    required this.isFavorite,
    required this.onIndexChanged,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  _MusicPlayersScreenState createState() => _MusicPlayersScreenState();
}

class _MusicPlayersScreenState extends State<MusicPlayersScreen> {
  String get currentSongImage => widget.musicList[widget.currentIndex].image;
  String get currentSongName => widget.musicList[widget.currentIndex].songName;
  late Duration totalDuration;
  late Duration currentPosition;
  late bool isPlaying;
  bool loopEnabled = false;

  @override
  void initState() {
    super.initState();
    totalDuration = const Duration();
    currentPosition = const Duration();
    isPlaying = true;

    widget.audioPlayer
        .setUrl(widget.musicList[widget.currentIndex].songURL)
        .then((_) => widget.audioPlayer.play());

    widget.audioPlayer.durationStream.listen((event) {
      setState(() {
        totalDuration = event ?? const Duration();
      });
    });

    widget.audioPlayer.positionStream.listen((event) {
      setState(() {
        currentPosition = event;
      });
    });

    widget.audioPlayer.playerStateStream.listen((event) {
      setState(() {
        isPlaying = event.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black12,
        title: const Text(
          'Now Playing',
          style: TextStyle(color: lr),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: widget.onFavoritePressed,
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            if (widget.currentIndex > 0) {
              widget.onIndexChanged(widget.currentIndex - 1);
              _playSelectedSong(widget.currentIndex - 1);
            }
          } else {
            if (widget.currentIndex < widget.musicList.length - 1) {
              widget.onIndexChanged(widget.currentIndex + 1);
              _playSelectedSong(widget.currentIndex + 1);
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 310,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.musicList[widget.currentIndex].image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  widget.musicList[widget.currentIndex].songName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.musicList[widget.currentIndex].singerName,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(currentPosition),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      formatDuration(totalDuration),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Slider(
                  value: currentPosition.inSeconds.toDouble().clamp(0.0, totalDuration.inSeconds.toDouble()),
                  onChanged: (value) {
                    setState(() {
                      currentPosition = Duration(seconds: value.toInt());
                    });
                    widget.audioPlayer.seek(currentPosition);
                  },
                  min: 0.0,
                  max: totalDuration.inSeconds.toDouble(),
                  activeColor: lr,
                  inactiveColor: Colors.white70,
                ),


                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                          Icons.loop, color: loopEnabled ? lr : Colors.white),
                      onPressed: () {
                        setState(() {
                          loopEnabled = !loopEnabled;
                        });
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: lr),
                      iconSize: 40,
                      onPressed: () {
                        if (widget.currentIndex > 0) {
                          widget.onIndexChanged(widget.currentIndex - 1);
                          _playSelectedSong(widget.currentIndex - 1);
                        }
                      },
                    ),
                    SizedBox(width: 35,),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          widget.audioPlayer.pause();
                        } else {
                          widget.audioPlayer.play();
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                    ),
                    SizedBox(width: 35,),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: lr),
                      iconSize: 40,
                      onPressed: () {
                        if (widget.currentIndex < widget.musicList.length - 1) {
                          widget.onIndexChanged(widget.currentIndex + 1);
                          _playSelectedSong(widget.currentIndex + 1);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 100),
                                child: Text('Lyrics',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: lr,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ZoomableLyricsPage(
                                                  musicList: widget.musicList,
                                                  currentIndex: widget
                                                      .currentIndex,
                                                ),
                                          ));
                                    },
                                    icon: const Icon(
                                      Icons.zoom_out_map_sharp,
                                      color: lr,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.musicList[widget.currentIndex].lyrics,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );


  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  // void _playSelectedSong(int index) {
  //   widget.audioPlayer.stop();
  //   widget.audioPlayer.seek(Duration.zero);
  //   widget.audioPlayer.setUrl(widget.musicList[index].songURL);
  //   widget.audioPlayer.play();
  // }
  void _playSelectedSong(int index) {
    widget.audioPlayer.stop();
    widget.audioPlayer.seek(Duration.zero);
    widget.audioPlayer.setUrl(widget.musicList[index].songURL);
    widget.audioPlayer.play();

    widget.audioPlayer.positionStream.listen((event) {
      setState(() {
        currentPosition = event;
        if (loopEnabled && currentPosition >= totalDuration) {
          // If loop is enabled and the current position exceeds the total duration, clamp it to the total duration
          widget.audioPlayer.seek(Duration.zero);
        }
      });
    });
  }

}





class ZoomableLyricsPage extends StatelessWidget {
  final List<MusicModel> musicList;
  final int currentIndex;

  const ZoomableLyricsPage({
    required this.musicList,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lr,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Lyrics',
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueGrey,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ZoomableLyricsContainer(
            musicList: musicList,
            currentIndex: currentIndex,
          ),
        ],
      ),
    );
  }
}

class ZoomableLyricsContainer extends StatefulWidget {
  final List<dynamic> musicList; // Replace 'dynamic' with your music type
  final int currentIndex;

  const ZoomableLyricsContainer({
    required this.musicList,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  _ZoomableLyricsContainerState createState() =>
      _ZoomableLyricsContainerState();
}

class _ZoomableLyricsContainerState extends State<ZoomableLyricsContainer> {
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    setState(() {
      _baseScaleFactor = _scaleFactor;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scaleFactor = _baseScaleFactor * details.scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: _scaleFactor,
                  child: Text(
                    widget.musicList[widget.currentIndex].lyrics,
                    style: const TextStyle(fontSize: 22, color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

