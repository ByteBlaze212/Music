// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
//
//
// class AudioPlayerWidget extends StatefulWidget {
//   const AudioPlayerWidget({Key? key}) : super(key: key);
//
//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }
//
// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   late MusicPlayer musicPlayer;
//
//   @override
//   void initState() {
//     super.initState();
//     musicPlayer = MusicPlayer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.black,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           StreamBuilder<Duration>(
//             stream: musicPlayer.audioPositionStream,
//             builder: (context, snapshot) {
//               final position = snapshot.data ?? Duration.zero;
//               return Text(
//                 '${position.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
//                     '${position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
//                 style: TextStyle(color: Colors.white),
//               );
//             },
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.skip_previous),
//                 onPressed: () {
//                   // Implement skip to previous logic
//                 },
//                 color: Colors.white,
//               ),
//               IconButton(
//                 icon: Icon(
//                   musicPlayer.isPlaying() ? Icons.pause : Icons.play_arrow,
//                 ),
//                 onPressed: () {
//                   if (musicPlayer.isPlaying()) {
//                     musicPlayer.pause();
//                   } else {
//                     musicPlayer.resume();
//                   }
//                   setState(() {});
//                 },
//                 color: Colors.white,
//                 iconSize: 64,
//               ),
//               IconButton(
//                 icon: Icon(Icons.skip_next),
//                 onPressed: () {
//                   // Implement skip to next logic
//                 },
//                 color: Colors.white,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MusicPlayer {
//   late AudioPlayer _audioPlayer;
//   late String _currentlyPlayingUrl;
//
//   MusicPlayer() {
//     _audioPlayer = AudioPlayer();
//     _currentlyPlayingUrl = '';
//   }
//
//   Future<void> play(String url) async {
//     if (_currentlyPlayingUrl == url) {
//       // If the same song is already playing, pause it
//       await _audioPlayer.pause();
//       _currentlyPlayingUrl = '';
//     } else {
//       // Play the selected song
//       int result = await _audioPlayer.play(url);
//       if (result == 1) {
//         // Successful playing
//         _currentlyPlayingUrl = url;
//       }
//     }
//   }
//
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     _currentlyPlayingUrl = '';
//   }
//
//   Future<void> pause() async {
//     await _audioPlayer.pause();
//   }
//
//   bool isPlaying() {
//     return _currentlyPlayingUrl.isNotEmpty;
//   }
//
//   bool isPaused() {
//     return _audioPlayer.state == PlayerState.PAUSED;
//   }
//
//   bool isStopped() {
//     return _audioPlayer.state == PlayerState.STOPPED;
//   }
//
//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'MusicModel.dart';
import 'color.dart';

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

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
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
      onIndexChanged: (int newIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      },
    );
  }
}


class MusicPlayersScreen extends StatefulWidget {
  final List<MusicModel> musicList;
  final int initialIndex;
  final AudioPlayer audioPlayer;
  final int currentIndex;
  final Function(int) onIndexChanged;

  const MusicPlayersScreen({
    Key? key,
    required this.musicList,
    required this.initialIndex,
    required this.audioPlayer,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  _MusicPlayersScreenState createState() => _MusicPlayersScreenState();
}

class _MusicPlayersScreenState extends State<MusicPlayersScreen> {
  late Duration totalDuration;
  late Duration currentPosition;
  late bool isPlaying;

  get musicList => widget.musicList;

  get currentIndex => widget.currentIndex;

  @override
  void initState() {
    super.initState();
    totalDuration = const Duration();
    currentPosition = const Duration();
    isPlaying = false;

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
        backgroundColor: Colors.black12,
        title: const Text(
          'Now Playing',
          style: TextStyle(color: lr),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Implement playlist screen navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 310, // Adjust the width as needed
                height: 300, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.musicList[widget.currentIndex].image),
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
                value: currentPosition.inSeconds.toDouble(),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: lr),
                    iconSize: 40,
                    onPressed: () {
                      if (widget.currentIndex > 0) {
                        widget.onIndexChanged(widget.currentIndex - 1);
                        widget.audioPlayer.stop();
                        widget.audioPlayer.seek(Duration.zero);
                        widget.audioPlayer.setUrl(widget.musicList[widget.currentIndex].songURL);
                        widget.audioPlayer.play();
                      }
                    },
                  ),
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
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: lr),
                    iconSize: 40,
                    onPressed: () {
                      if (widget.currentIndex < widget.musicList.length - 1) {
                        widget.onIndexChanged(widget.currentIndex + 1);
                        widget.audioPlayer.stop();
                        widget.audioPlayer.seek(Duration.zero);
                        widget.audioPlayer.setUrl(widget.musicList[widget.currentIndex].songURL);
                        widget.audioPlayer.play();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                 width: double.infinity,
                 height: 450,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                  ),
                  child: SingleChildScrollView(
                    child: Column(

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Text('Lyrics',style:TextStyle(fontSize: 24,color:lr,fontStyle:FontStyle.italic,
                                  fontWeight:FontWeight.w500  )),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: IconButton(onPressed:(){
                               Navigator.push(context, MaterialPageRoute(builder:(context) =>
                                   ZoomableLyricsPage(
                                     musicList: musicList,
                                     currentIndex: currentIndex,
                                   ),));
                              }, icon: Icon(Icons.zoom_out_map_sharp,color: lr,)),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.musicList[widget.currentIndex].lyrics,
                            style: const TextStyle(fontSize: 18, color:Colors.white60),
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
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
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
         title: Text(
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

          //SizedBox(height: 45,),
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
  _ZoomableLyricsContainerState createState() => _ZoomableLyricsContainerState();
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
        borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 20),
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