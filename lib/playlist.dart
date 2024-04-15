import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_melo/player.dart';
import 'package:user_melo/playlistFetch.dart';
import 'MusicModel.dart';
import 'color.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}


class _PlayListState extends State<PlayList> {


  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            PBlue,
            Colors.black12,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Playlist', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Newplaylist(),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Image.asset('assets/images/playlist.png', height: 50, width: 80,),
                          const SizedBox(width: 10,),
                          const Text('New playlist', style: TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20 ,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => LikedSongsWidget(),));
                  },
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LikedSongsWidget(),));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
                      ),
                      height: 60,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Image.asset('assets/images/likedsongs.png', height: 50, width: 80,),
                            const SizedBox(width: 10,),
                            const Text('Liked Songs', style: TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20 ,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyPlaylist(),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Image.asset('assets/images/playlistF.png', height: 50, width: 80,),
                          const SizedBox(width: 10,),
                          const Text("Your playlist's", style: TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

  ]),
        ),
      ),
    );
  }
}






class LikedSongsWidget extends StatefulWidget {
  const LikedSongsWidget({Key? key}) : super(key: key);

  @override
  _LikedSongsWidgetState createState() => _LikedSongsWidgetState();
}
class _LikedSongsWidgetState extends State<LikedSongsWidget> {
  late Future<List<MusicModel>> _likedSongsFuture;

  @override
  void initState() {
    super.initState();
    _likedSongsFuture = _fetchLikedSongs();
  }

  Future<List<MusicModel>> _fetchLikedSongs() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final CollectionReference likedSongsCollection =
        FirebaseFirestore.instance.collection('user').doc(user.uid).collection('liked_songs');

        final QuerySnapshot querySnapshot = await likedSongsCollection.get();
        final List<MusicModel> likedSongs = querySnapshot.docs.map((doc) {
          // Map each document to a MusicModel object
          return MusicModel(
            songName: doc['song'],
            songURL: doc['url'],
            singerName: doc['singer'],
            category: doc['genre'],
            image: doc['image'],
            lyrics: doc['lyrics'],
            id: '',
          );
        }).toList();

        return likedSongs;
      }
    } catch (e) {
      print('Error fetching liked songs: $e');
    }
    return []; // Return empty list if fetching failed
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Bgr1,
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Liked Songs',style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<MusicModel>>(
          future: _likedSongsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<MusicModel>? likedSongs = snapshot.data;
              if (likedSongs != null && likedSongs.isNotEmpty) {
                return ListView.builder(
                  itemCount: likedSongs.length,
                  itemBuilder: (context, index) {
                    final MusicModel song = likedSongs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              MusicPlayerScreenController(initialIndex: index, musicList:snapshot.data!),));
                        },
                        child: Card(
                          color: Colors.white38,
                          elevation: 20,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                song.image, // Assuming image is a URL
                                width: 50, // Adjust width as needed
                                height: 50, // Adjust height as needed
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              song.songName.length > 15
                                  ? '${song.songName.substring(0, 15)}...'
                                  : song.songName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis, // Enable overflow handling
                            ),
                            subtitle: Text(song.singerName),
                            // You can customize the list item as needed
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No liked songs found'));
              }
            }
          },
        ),
      ),
    );
  }
}
 class Newplaylist extends StatefulWidget {
  const Newplaylist({Key? key}) : super(key: key);

  @override
  State<Newplaylist> createState() => NewplaylistState();
}


class NewplaylistState extends State<Newplaylist> {
  TextEditingController _playlistName = TextEditingController();
  // Define playlistName at the class level

  Future<void> _createPlaylist(String playlistName) async {
    try {
      CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await userCollection.doc(user.uid).collection('playlist').doc(playlistName).set({'playlistName': playlistName});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Playlist created!'),
        ));

      }
    } catch (e) {
      print('Error creating playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to create Playlist'),
      ));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey,
              ),
              height: 230,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'New Playlist',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _playlistName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.blue,
                          hintText: 'Enter new playlist name',
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        String name = _playlistName.text.trim();
                        if (name.isNotEmpty) {
                          _createPlaylist(name);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => selectPlaylistmusic(playlistName: name),));
                          _playlistName.clear();
                        } else {
                          print('Please enter a valid playlist name');
                        }
                      },
                      child: Container(
                        height: 50,
                        color: Colors.blue,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Create Playlist',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class selectPlaylistmusic extends StatefulWidget {
  final String playlistName;
  const selectPlaylistmusic({Key? key, required this.playlistName}) : super(key: key);

  @override
  State<selectPlaylistmusic> createState() => _selectPlaylistmusicState();
}

class _selectPlaylistmusicState extends State<selectPlaylistmusic> {
  List<MusicModel> selectedSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PBlue,
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Expanded( // Wrap with Expanded
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 700,
                child: AllMusicList1(
                  playlistName: widget.playlistName,
                  onSongSelected: (song) {
                    setState(() {
                      if (selectedSongs.contains(song)) {
                        selectedSongs.remove(song);
                      } else {
                        selectedSongs.add(song);
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedSongs.isNotEmpty) {
                _addToPlaylist(selectedSongs);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayList() ,));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No songs selected to add to playlist!'),
                ));
              }
            },
            child: Text('Add Selected Songs to Playlist'),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Future<void> _addToPlaylist(List<MusicModel> songs) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference playlistCollection = FirebaseFirestore.instance.collection('user').doc(user.uid).collection('playlist');
        DocumentReference playlistDocRef = playlistCollection.doc(widget.playlistName);

        for (MusicModel song in songs) {
          await playlistDocRef.collection('songs').add({
            'song': song.songName,
            'url': song.songURL,
            'singer': song.singerName,
            'genre': song.category,
            'image': song.image,
            'lyrics': song.lyrics,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Songs added to playlist!'),
        ));

        setState(() {
          selectedSongs.clear();
        });
      }
    } catch (e) {
      print('Error adding songs to playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add songs to playlist'),
      ));
    }
  }
}



class AllMusicList1 extends StatefulWidget {
  final String playlistName;
  final Function(MusicModel) onSongSelected;
  const AllMusicList1({Key? key, required this.playlistName, required this.onSongSelected}) : super(key: key);

  @override
  State<AllMusicList1> createState() => _AllMusicList1State();
}

class _AllMusicList1State extends State<AllMusicList1> {
  List<int> selectedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }
        final productDocs = snapshot.data!.docs;

        if (productDocs.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: productDocs.length,
          itemBuilder: (context, index) {
            final product = MusicModel.fromSnapshot(productDocs[index]);

            return GestureDetector(
              onTap: () {
                widget.onSongSelected(product);
                setState(() {
                  if (selectedIndexes.contains(index)) {
                    selectedIndexes.remove(index);
                  } else {
                    selectedIndexes.add(index);
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  if (selectedIndexes.contains(index)) {
                    selectedIndexes.remove(index);
                  } else {
                    selectedIndexes.add(index);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: selectedIndexes.contains(index)
                      ? Border.all(color: Colors.red, width: 2.0)
                      : null,
                  color: selectedIndexes.contains(index) ? Colors.transparent : Colors.black54,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            product.songName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Singer: ${product.singerName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
