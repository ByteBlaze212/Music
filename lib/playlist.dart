import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_melo/player.dart';

import 'MusicModel.dart';
import 'color.dart';
import 'homePage.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
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
          backgroundColor:Colors.transparent,
          title: Text('Playlist',style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body:Column(
           children: [
             SizedBox(height: 30,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => LikedSongsWidget(),));
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
                         Image.asset('assets/images/likedsongs.png',height: 50,width: 80,),
                         SizedBox(width: 10,),
                         Text('liked songs',style: TextStyle(color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic)),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 20 ,),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector(
                 onTap: (){
                   //Navigator.push(context, MaterialPageRoute(builder: (context) => LikedSongsWidget(),));
                 },
                 child: GestureDetector(
                   onTap: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context) => Newplaylist(),));
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
                           Image.asset('assets/images/playlist.png',height: 50,width: 80,),
                           SizedBox(width: 10,),
                           Text('New playlist',style: TextStyle(color: Colors.white,fontSize: 18,fontStyle: FontStyle.italic)),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             )

           ],
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
            lyrics: doc['lyrics'], id: '',
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
      decoration: BoxDecoration(
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
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Liked Songs',style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<MusicModel>>(
          future: _likedSongsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>
                              MusicPlayerScreenController(initialIndex: index,
                                  musicList:snapshot.data!),));
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
                            title:Text(
                              song.songName.length > 15
                                  ? '${song.songName.substring(0, 15)}...'
                                  : song.songName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              overflow: TextOverflow
                                  .ellipsis, // Enable overflow handling
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
                return Center(child: Text('No liked songs found'));
              }
            }
          },
        ),
      ),
    );
  }
}


// class Newplaylist extends StatefulWidget {
//   const Newplaylist({Key? key}) : super(key: key);
//
//   @override
//   State<Newplaylist> createState() => _NewplaylistState();
// }
//
// class _NewplaylistState extends State<Newplaylist> {
//   TextEditingController _playlistName = TextEditingController();
//
//   Future<void> _createPlaylist(String playlistName) async {
//     try {
//       // Get reference to the 'user' collection
//       CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
//
//       // Get current user
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Add a new document to the 'playlist' subcollection under the user
//         await userCollection.doc(user.uid).collection('playlist').doc(playlistName).set({
//           //'name': playlistName,
//           // You can add more fields if needed
//         });
//
//         // Show a snackbar to indicate success
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Playlist created!'),
//         ));
//       }
//     } catch (e) {
//       // Handle errors
//       print('Error creating playlist: $e');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Failed to create Playlist'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black12,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.blueGrey,
//               ),
//               height: 230,
//               child: Column(
//                 children: [
//                   SizedBox(height: 15),
//                   Text(
//                     'New Playlist',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         controller: _playlistName,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           fillColor: Colors.blue,
//                           hintText: 'Enter new playlist name',
//                           labelStyle: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         String name = _playlistName.text.trim();
//
//                         if (name.isNotEmpty) {
//                           _createPlaylist(name);
//                           Navigator.push(context,MaterialPageRoute(builder: (context) =>
//                               selectPlaylistmusic(),));
//
//                           // Clear the text field after creating the playlist
//                           _playlistName.clear();
//                         } else {
//                           print('Please enter a valid playlist name');
//                         }
//                       },
//                       child: Container(
//                         height: 50,
//                         color: Colors.blue, // Change to your desired color
//                         width: double.infinity,
//                         child: Center(
//                           child: Text(
//                             'Create Playlist',
//                             style: TextStyle(color: Colors.white, fontSize: 17),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

// class selectPlaylistmusic extends StatefulWidget {
//   const selectPlaylistmusic({Key? key});
//
//   @override
//   State<selectPlaylistmusic> createState() => _selectPlaylistmusicState();
// }
//
// class _selectPlaylistmusicState extends State<selectPlaylistmusic> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: PBlue
//       ,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 15,),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 height: 750,
//                 child: AllMusicList1(),
//               ),
//             ),
//             GestureDetector(
//               onTap: (){
//
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   width: double.infinity,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Bgr2,
//                     borderRadius: BorderRadius.zero,
//                   ),
//                   child: Center(child: Text('Add to Playlist',style: TextStyle(color: Colors.white,
//                       fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,fontSize: 17),)),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AllMusicList1 extends StatefulWidget {
//   const AllMusicList1({Key? key}) : super(key: key);
//
//   @override
//   State<AllMusicList1> createState() => _AllMusicList1State();
// }
//
// class _AllMusicList1State extends State<AllMusicList1> {
//   List<int> selectedIndexes = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(color: Colors.black),
//           );
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return Center(child: Text('No data available'));
//         }
//         final productDocs = snapshot.data!.docs;
//
//         if (productDocs.isEmpty) {
//           return Center(child: Text('No products available'));
//         }
//
//         return GridView.builder(
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: productDocs.length,
//           itemBuilder: (context, index) {
//             final product = MusicModel.fromSnapshot(productDocs[index]);
//
//             return GestureDetector(
//               onTap: () {
//                 // Check if item is selected
//                 if (selectedIndexes.contains(index)) {
//                   setState(() {
//                     // Deselect item
//                     selectedIndexes.remove(index);
//                   });
//                 } else {
//                   // Handle tap
//                 }
//               },
//               onLongPress: () {
//                 setState(() {
//                   // Toggle selection
//                   if (selectedIndexes.contains(index)) {
//                     selectedIndexes.remove(index);
//                   } else {
//                     selectedIndexes.add(index);
//                   }
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: selectedIndexes.contains(index)
//                       ? Border.all(color: Colors.red, width: 2.0)
//                       : null,
//                   color: selectedIndexes.contains(index) ? Colors.transparent : Colors.black54,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 150,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.network(
//                           product.image,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             product.songName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             'Singer: ${product.singerName}',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }





 class Newplaylist extends StatefulWidget {
  const Newplaylist({Key? key}) : super(key: key);

  @override
  State<Newplaylist> createState() => NewplaylistState();
}

class NewplaylistState extends State<Newplaylist> {
  TextEditingController _playlistName = TextEditingController();

  Future<void> _createPlaylist(String playlistName) async {
    try {
      // Get reference to the 'user' collection
      CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

      // Get current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Add a new document to the 'playlist' subcollection under the user
        await userCollection.doc(user.uid).collection('playlist').doc(playlistName).set({
          //'name': playlistName,
          // You can add more fields if needed
        });

        // Show a snackbar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Playlist created!'),
        ));
      }
    } catch (e) {
      // Handle errors
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
                  SizedBox(height: 15),
                  Text(
                    'New Playlist',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
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
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        String name = _playlistName.text.trim();

                        if (name.isNotEmpty) {
                          _createPlaylist(name);
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>
                              selectPlaylistmusic(playlistName: name),));

                          // Clear the text field after creating the playlist
                          _playlistName.clear();
                        } else {
                          print('Please enter a valid playlist name');
                        }
                      },
                      child: Container(
                        height: 50,
                        color: Colors.blue, // Change to your desired color
                        width: double.infinity,
                        child: Center(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PBlue
      ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 700,
                child: AllMusicList1(playlistName: widget.playlistName),
              ),
            ),
            GestureDetector(
              onTap: (){

              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Bgr2,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Center(child: Text('Add to Playlist',style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,fontSize: 17),)),
                ),
              ),
            )
          ],

        ),
      ),
    );
  }
}

class AllMusicList1 extends StatefulWidget {
  final String playlistName;
  const AllMusicList1({Key? key, required this.playlistName}) : super(key: key);

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
          return Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data available'));
        }
        final productDocs = snapshot.data!.docs;

        if (productDocs.isEmpty) {
          return Center(child: Text('No products available'));
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                // Check if item is selected
                if (selectedIndexes.contains(index)) {
                  setState(() {
                    // Deselect item
                    selectedIndexes.remove(index);
                  });
                } else {
                  // Handle tap
                }
              },
              onLongPress: () {
                setState(() {
                  // Toggle selection
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Singer: ${product.singerName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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



// class Newplaylist extends StatefulWidget {
//   final String playlistName;
//   final List<MusicModel> selectedItems; // Add selectedItems
//   const Newplaylist({Key? key, required this.playlistName, required this.selectedItems}) : super(key: key);
//
//   @override
//   State<Newplaylist> createState() => NewplaylistState();
// }
//
// class NewplaylistState extends State<Newplaylist> {
//   TextEditingController _playlistName = TextEditingController();
//
//   Future<void> _createPlaylist(String playlistName, List<MusicModel> selectedItems) async {
//     try {
//       CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
//       final User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         await userCollection.doc(user.uid).collection('playlist').doc(playlistName).set({});
//
//         for (var item in selectedItems) {
//           await userCollection.doc(user.uid).collection('playlist').doc(playlistName).collection('songs').add({
//             'songName': item.songName,
//             'singerName': item.singerName,
//             'image': item.image,
//             'category': item.category,
//             // Add more fields as needed
//           });
//         }
//
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Playlist created!'),
//         ));
//       }
//     } catch (e) {
//       print('Error creating playlist: $e');
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Failed to create Playlist'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black12,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.blueGrey,
//               ),
//               height: 230,
//               child: Column(
//                 children: [
//                   SizedBox(height: 15),
//                   Text(
//                     'New Playlist',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         controller: _playlistName,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           fillColor: Colors.blue,
//                           hintText: 'Enter new playlist name',
//                           labelStyle: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         String name = _playlistName.text.trim();
//
//                         if (name.isNotEmpty) {
//                           _createPlaylist(name, widget.selectedItems); // Pass selected items
//                           Navigator.pop(context); // Go back to previous screen
//
//                           _playlistName.clear();
//                         } else {
//                           print('Please enter a valid playlist name');
//                         }
//                       },
//                       child: Container(
//                         height: 50,
//                         color: Colors.blue,
//                         width: double.infinity,
//                         child: Center(
//                           child: Text(
//                             'Create Playlist',
//                             style: TextStyle(color: Colors.white, fontSize: 17),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class selectPlaylistmusic extends StatefulWidget {
//   final String playlistName;
//   const selectPlaylistmusic({Key? key, required this.playlistName}) : super(key: key);
//
//   @override
//   State<selectPlaylistmusic> createState() => _selectPlaylistmusicState();
// }
//
// class _selectPlaylistmusicState extends State<selectPlaylistmusic> {
//   List<MusicModel> selectedItems = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: PBlue,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20,),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 height: 700,
//                 child: AllMusicList1(
//                   playlistName: widget.playlistName,
//                   onSelectedItemsChanged: (items) {
//                     setState(() {
//                       selectedItems = items;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Newplaylist(
//                       playlistName: widget.playlistName,
//                       selectedItems: selectedItems,
//                     ),
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   width: double.infinity,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: Bgr2,
//                     borderRadius: BorderRadius.zero,
//                   ),
//                   child: Center(child: Text('Add to Playlist',style: TextStyle(color: Colors.white,
//                       fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,fontSize: 17),)),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AllMusicList1 extends StatefulWidget {
//   final String playlistName;
//   final Function(List<MusicModel>) onSelectedItemsChanged;
//   const AllMusicList1({Key? key, required this.playlistName, required this.onSelectedItemsChanged}) : super(key: key);
//
//   @override
//   State<AllMusicList1> createState() => _AllMusicList1State();
// }
//
// class _AllMusicList1State extends State<AllMusicList1> {
//   List<int> selectedIndexes = [];
//   List<MusicModel> selectedItems = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(color: Colors.black),
//           );
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return Center(child: Text('No data available'));
//         }
//         final productDocs = snapshot.data!.docs;
//
//         if (productDocs.isEmpty) {
//           return Center(child: Text('No products available'));
//         }
//
//         return GridView.builder(
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: productDocs.length,
//           itemBuilder: (context, index) {
//             final product = MusicModel.fromSnapshot(productDocs[index]);
//
//             return GestureDetector(
//               onTap: () {
//                 if (selectedIndexes.contains(index)) {
//                   setState(() {
//                     selectedIndexes.remove(index);
//                     selectedItems.remove(product);
//                   });
//                 } else {
//                   setState(() {
//                     selectedIndexes.add(index);
//                     selectedItems.add(product);
//                   });
//                 }
//                 widget.onSelectedItemsChanged(selectedItems); // Notify parent widget
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: selectedIndexes.contains(index)
//                       ? Border.all(color: Colors.red, width: 2.0)
//                       : null,
//                   color: selectedIndexes.contains(index) ? Colors.transparent : Colors.black54,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 150,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.network(
//                           product.image,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             product.songName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             'Singer: ${product.singerName}',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class MusicModel {
//   final String songName;
//   final String singerName;
//   final String image;
//   final String category;
//
//   MusicModel({
//     required this.songName,
//     required this.singerName,
//     required this.image,
//     required this.category,
//   });
//
//   factory MusicModel.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return MusicModel(
//       songName: data['songName'] ?? '',
//       singerName: data['singerName'] ?? '',
//       image: data['image'] ?? '',
//       category: data['category'] ?? '',
//     );
//   }
// }
