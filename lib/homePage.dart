// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:user_melo/PunjabiSongs.dart';
// import 'package:user_melo/color.dart';
//
// import 'CategoryModel.dart';
// import 'MusicModel.dart';
//
// class HomePage1 extends StatefulWidget {
//   const HomePage1({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage1> createState() => _HomePage1State();
// }
//
// class _HomePage1State extends State<HomePage1> {
//
//   Future<bool> _onWillPop() async {
//     bool exitConfirmed = false;
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(
//           'Exit Music App?',
//           style: TextStyle(
//               fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Do you want to exit the app?',
//           style: TextStyle(
//               fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//               exitConfirmed = false;
//             },
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//               exitConfirmed = true;
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//     return exitConfirmed;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black12, PBlue],
//             begin: Alignment.center,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.black26,
//             title: const Text(
//               'Melo',
//               style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontStyle: FontStyle.italic),
//             ),
//             centerTitle: true,
//
//           ),
//           body: Container(
//
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle("Genre"),
//                   const SizedBox(height: 10),
//                   const CategoryList(),
//                   const SizedBox(height: 20),
//                   _buildSectionTitle("Upcoming Songs"),
//                   const SizedBox(height: 10),
//                   const BannerList(),
//                   const SizedBox(height: 20),
//                   _buildSectionTitle("All Musics"),
//                   const SizedBox(height: 10),
//                   const AllMusicList(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 25,
//         fontStyle: FontStyle.italic,
//         color: Colors.white,
//       ),
//     );
//   }
// }
//
// class CategoryList extends StatelessWidget {
//   const CategoryList({super.key});
//
//   //get category => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Category').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ));
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('No data available'));
//         }
//         final categoryDocs = snapshot.data!.docs;
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: categoryDocs.map((doc) {
//               final category = CategoryModel.fromDocument(doc);
//               return GestureDetector(onTap: (){
//               },child: CategoryCard(category: category));
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class BannerList extends StatelessWidget {
//   const BannerList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Banner').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ));
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error: ${snapshot.error}',
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text(
//               'No banners found',
//               style: TextStyle(color: Colors.white),
//             ),
//           );
//         } else {
//           List<QueryDocumentSnapshot> banners = snapshot.data!.docs;
//           return CarouselSlider.builder(
//             itemCount: banners.length,
//             itemBuilder: (context, index, realIndex) {
//               final banner = banners[index];
//               String imageUrl = banner['image'];
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.symmetric(horizontal: 6),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               height: 310.0,
//               enableInfiniteScroll: true,
//               autoPlay: true,
//               autoPlayInterval: const Duration(seconds: 3),
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enlargeCenterPage: true,
//               scrollDirection: Axis.horizontal,
//             ),
//           );
//         }
//       },
//     );
//   }
// }
//
// class AllMusicList extends StatelessWidget {
//   const AllMusicList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.black,
//               ));
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('No data available'));
//         }
//         final productDocs = snapshot.data!.docs;
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: productDocs.length,
//           itemBuilder: (context, index) {
//             final product = MusicModel.fromSnapshot(productDocs[index]);
//             return MusicCard(product: product);
//           },
//         );
//       },
//     );
//   }
// }
//
// class CategoryCard extends StatelessWidget {
//   final CategoryModel category;
//
//   const CategoryCard({Key? key, required this.category}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 100,
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => PunjabiSongs(selectedcategory: category)));
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 80,
//               width: 80,
//               child: ClipOval(
//                 child: Image.network(
//                   category.image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               category.genre,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white60,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MusicCard extends StatelessWidget {
//   final MusicModel product;
//
//   const MusicCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // // Splitting the audio duration string by ':'
//     // List<int> parts = product.audioDuration.split(':');
//     //
//     // // Extracting minutes and seconds components
//     // int minutes = int.parse(parts[1]);
//     // int seconds =
//     // int.parse(parts[2].split('.')[0]); // Removing milliseconds part
//     //
//     // // Format duration string
//     // String durationString = '$minutes:${seconds.toString().padLeft(2, '0')}';
//
//     return GestureDetector(
//       // onTap: () {
//       //   Navigator.of(context).push(
//       //     MaterialPageRoute(builder: (context) => MusicPlayerScreen()),
//       //   );
//       // },
//       child: Container(
//         height: 200,
//         width: 150,
//         color: Colors.black45,
//
//         child: Column(
//           children: [
//             Card(
//
//
//               color: Colors.black45,
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 150,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         product.image,
//                          fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//
//                   // Container(
//                   //   height: 42,
//                   //   color: Colors.black,
//                   //   child: Column(
//                   //     children: [
//                   //       Padding(
//                   //         padding: const EdgeInsets.symmetric(horizontal: 8),
//                   //         child: Text(
//                   //           product.songName,
//                   //           maxLines: 1,
//                   //           overflow: TextOverflow.ellipsis,
//                   //           style: const TextStyle(
//                   //             fontSize: 15,
//                   //             fontWeight: FontWeight.bold,
//                   //             color: Colors.white60
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       Padding(
//                   //         padding: const EdgeInsets.symmetric(horizontal: 8),
//                   //         child: Text(
//                   //           'Singer: ${product.singerName}',
//                   //           style: const TextStyle(
//                   //             fontSize: 13,
//                   //             fontWeight: FontWeight.bold,
//                   //             color: Colors.grey,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   //
//                   // ),
//                   //const SizedBox(height: 5),
//
//
//                   // Padding(
//                   //   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   //   child: Text(
//                   //     'Duration: $durationString',
//                   //     style: const TextStyle(
//                   //       fontSize: 12,
//                   //       fontWeight: FontWeight.bold,
//                   //       color: Colors.green,
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//
//
//       Container(
//         height: 62,
//         color: Colors.black54,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 product.songName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white60
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 'Singer: ${product.singerName}',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//       ),
//         ]),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_melo/PunjabiSongs.dart';
import 'package:user_melo/color.dart';
import 'package:user_melo/player.dart';

import 'CategoryModel.dart';
import 'MusicModel.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  Future<bool> _onWillPop() async {
    bool exitConfirmed = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Exit Music App?',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Do you want to exit the app?',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              exitConfirmed = false;
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              exitConfirmed = true;
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return exitConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black12, PBlue],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black26,
            title: const Text(
              'Melo',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            centerTitle: true,
          ),
          body: Container(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Genre"),
                  const SizedBox(height: 10),
                  const CategoryList(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Upcoming Songs"),
                  const SizedBox(height: 10),
                  const BannerList(),
                  const SizedBox(height: 20),
                  _buildSectionTitle("All Musics"),
                  const SizedBox(height: 10),
                  const AllMusicList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }
        final categoryDocs = snapshot.data!.docs;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryDocs.map((doc) {
              final category = CategoryModel.fromDocument(doc);
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PunjabiSongs(selectedCategory: category)));
                  },
                  child: CategoryCard(category: category));
            }).toList(),
          ),
        );
      },
    );
  }
}

class BannerList extends StatelessWidget {
  const BannerList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Banner').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No banners found',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          List<QueryDocumentSnapshot> banners = snapshot.data!.docs;
          return CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = banners[index];
              String imageUrl = banner['image'];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 310.0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
        }
      },
    );
  }
}

class AllMusicList extends StatelessWidget {
  const AllMusicList({Key? key});

  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }
        final productDocs = snapshot.data!.docs;
        return GestureDetector(
          // onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> MusicPlayersScreen(musicList: [], initialIndex: index)))},
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
    //onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>
              //     MusicPlayerScreenController(musicList: widget.musicList, initialIndex: Index));},
                  child: MusicCard(product: product));
            },
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PunjabiSongs(selectedCategory: category)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: ClipOval(
                child: Image.network(
                  category.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              category.genre,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final MusicModel product;



  const MusicCard({Key? key, required this.product}) : super(key: key);






  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       //onTap: (){Navigator.push(context, MaterialPageRoute(builder:(context) => MusicPlayerScreenController(musicList: musicList, initialIndex: initialIndex),));},
      child: Container(
        height: 200,
        width: 150,
        color: Colors.black45,
        child: Column(
          children: [
            Card(
              color: Colors.black45,
              elevation: 4,
              shape: RoundedRectangleBorder(
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
                ],
              ),
            ),
            Container(
              height: 62,
              color: Colors.black54,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      product.songName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Singer: ${product.singerName}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PunjabiSongs extends StatefulWidget {
  final CategoryModel selectedCategory;

  const PunjabiSongs({required this.selectedCategory});

  @override
  State<PunjabiSongs> createState() => _PunjabiSongsState();
}

class _PunjabiSongsState extends State<PunjabiSongs> {
  CollectionReference GenreRef = FirebaseFirestore.instance.collection(
      'SubCategories');

  Future<List<MusicModel>> readMusic() async {
    QuerySnapshot response = await GenreRef.get();
    return response.docs.map((e) => MusicModel.fromSnapshot(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [lr, Colors.black54],
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.selectedCategory.genre,style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<MusicModel>>(
            future: readMusic().then((value) =>
                value.where((element) => element.category ==
                    widget.selectedCategory.genre).toList()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              final musicDocs = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: musicDocs.length,
                itemBuilder: (context, index) {
                  final music = musicDocs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                           // MusicPlayersScreen(musicList: snapshot.data!, initialIndex: index)
                          MusicPlayerScreenController(musicList: snapshot.data!, initialIndex: index)
                        ));
                      },
                      child: Card(
                        color: Colors.black26,
                        elevation: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Display the image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                music.image,
                                height: 65,
                                width: 55,
                                fit: BoxFit.cover,
                              ),
                            ),


                            //const SizedBox(width: 8),
                            // Display the song name

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    music.songName.length > 15 ? '${music.songName.substring(0, 15)}...' : music.songName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                   color:  Colors.white70),
                                    overflow: TextOverflow.ellipsis, // Enable overflow handling
                                  ),

                              //const SizedBox(height: 4),
                              // Display the singer name
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Text(
                                  'Singer: ${music.singerName}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
      ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}