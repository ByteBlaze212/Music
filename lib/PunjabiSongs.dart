// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
//
// import 'MusicModel.dart';
//
// class PunjabiSongs extends StatefulWidget {
//   final MusicModel selectedcategory;
//
//   const PunjabiSongs ({required this.selectedcategory});
//
//   @override
//   State<PunjabiSongs > createState() => _PunjabiSongsState();
// }
//
// class _PunjabiSongsState extends State<PunjabiSongs> {
//
//   CollectionReference GenreRef = FirebaseFirestore.instance.collection('SubCategories');
//
//
//   Future<List<MusicModel>> readBrand() async
//   {
//     QuerySnapshot response = await GenreRef.get();
//     return response.docs.map((e) => MusicModel.fromSnapshot(e)).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Punjabi Songs'),
//       ),
//       body: SingleChildScrollView(
//         child: FutureBuilder<List<MusicModel>>(
//           future: readBrand().then((value) => value.where((element) => element.category== widget.selectedcategory.category).toList()),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || snapshot.data == null) {
//               return const Center(child: Text('No data available'));
//             }
//
//             final SubCategoriesDocs = snapshot.data!;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: SubCategoriesDocs.map((category) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: MusicCard(category: category),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 const SizedBox(height: 20), // Add spacing between brand cards and products
//                 //ProductHome(selectedCategory: widget.selectedcategory.category)
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
// class MusicCard extends StatelessWidget {
//
//   final MusicModel category;
//
//   const MusicCard({Key? key, required this.category ,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         width: 150,
//         child: GestureDetector(
//           // onTap: () {
//           //   Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //         builder: (context) => ProductScreen(seletedBrand: brand,products: [],)
//           //     ),
//           //   );
//           // },
//           child: Card(
//             color: Colors.white,
//             elevation: 1,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: ClipOval(
//                     child: Image.network(
//                       category.image,
//                        fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20,),
//                 Text(
//                   category.category,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
