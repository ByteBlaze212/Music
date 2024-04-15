import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_melo/player.dart';
import 'package:user_melo/playlist.dart';
import 'color.dart';



class MyPlaylist extends StatefulWidget {
  const MyPlaylist({super.key});

  @override
  State<MyPlaylist> createState() => _MyPlaylistState();
}
class _MyPlaylistState extends State<MyPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(" Your Playlist's",style: TextStyle(color: Colors.white)),
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text(" Your Playlist's",style: TextStyle(color: Colors.white)),
            SizedBox(height: 30,),
            Container(
              color: Colors.black,

                width: double.infinity,
                height: 1000,
                child: PlaylistFetcher()),
          ],
        ),
      ),
    );
  }
}

class PlaylistFetcher extends StatefulWidget {
  const PlaylistFetcher({Key? key}) : super(key: key);

  @override
  _PlaylistFetcherState createState() => _PlaylistFetcherState();
}

class _PlaylistFetcherState extends State<PlaylistFetcher> {
  late Future<List<String>> _playlistNamesFuture;

  @override
  void initState() {
    super.initState();
    _playlistNamesFuture = _fetchPlaylistNames();
  }

  Future<List<String>> _fetchPlaylistNames() async {
    List<String> playlistNames = [];
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot playlistSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('playlist')
            .get();
        playlistSnapshot.docs.forEach((doc) {
          playlistNames.add(doc['playlistName']);
        });
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }
    return playlistNames;
  }

  Future<void> _deletePlaylist(String playlistName) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('playlist')
            .doc(playlistName)
            .delete();
        setState(() {
          // Refresh the UI after deletion
          _playlistNamesFuture = _fetchPlaylistNames();
        });
      }
    } catch (e) {
      print('Error deleting playlist: $e');
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _playlistNamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<String>? playlistNames = snapshot.data;
          if (playlistNames != null && playlistNames.isNotEmpty) {
            return ListView.builder(
              itemCount: playlistNames.length,
              itemBuilder: (context, index) {
                final String playlistName = playlistNames[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlaylistContentsScreen(playlistName: playlistName),
                      ));
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: lr,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              playlistName,
                              style: TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              _deletePlaylist(playlistName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No playlists found'));
          }
        }
      },
    );
  }
}



class PlaylistContentsScreen extends StatefulWidget {
  final String playlistName;

  const PlaylistContentsScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  _PlaylistContentsScreenState createState() => _PlaylistContentsScreenState();
}

class _PlaylistContentsScreenState extends State<PlaylistContentsScreen> {
  late Future<List<Map<String, dynamic>>> _playlistContentsFuture;

  @override
  void initState() {
    super.initState();
    _playlistContentsFuture = _fetchPlaylistContents(widget.playlistName);
  }

  Future<void> _removeSong(String songName) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('playlist')
            .doc(widget.playlistName)
            .collection('songs')
            .where('song', isEqualTo: songName) // Adjust based on your document structure
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
        setState(() {
          // Refresh the UI after removing the song
          _playlistContentsFuture = _fetchPlaylistContents(widget.playlistName);
        });
      }
    } catch (e) {
      print('Error removing song: $e');
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            lr,
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  selectPlaylistmusic(playlistName: widget.playlistName)));

            },
                icon: Icon(Icons.add,color: Colors.white,)),
          )] ,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.playlistName,
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 26, fontWeight: FontWeight.w400),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _playlistContentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<Map<String, dynamic>> playlistContents = snapshot.data!;
              return ListView.builder(
                itemCount: playlistContents.length,
                itemBuilder: (context, index) {
                  final songName = playlistContents[index]['songName'] ?? 'Unknown Song';
                  final singer = playlistContents[index]['singer'] ?? 'Unknown Singer';
                  final imageUrl = playlistContents[index]['imageUrl'];

                  return GestureDetector(
                    onTap: () {
                      // You can implement functionality when the song is tapped
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        color: Colors.white38,
                        child: ListTile(
                          leading: imageUrl != null
                              ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : SizedBox.shrink(),
                          title: Text(
                            songName.length > 15 ? '${songName.substring(0, 15)}...' : songName,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('$singer'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeSong(songName);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPlaylistContents(String playlistName) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final playlistSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('playlist')
          .doc(playlistName)
          .collection('songs')
          .get();
      return playlistSnapshot.docs.map((doc) {
        return {
          'songName': doc['song'] ?? '',
          'singer': doc['singer'] ?? '',
          'imageUrl': doc['image'],
        };
      }).toList();
    }
    throw 'User not authenticated';
  }
}

