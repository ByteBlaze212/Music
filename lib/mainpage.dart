// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:user_melo/color.dart';
//
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomLeft,
//           colors: [ Colors.black12,PBlue],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           children: [
//             Expanded(
//               child: CategoryListWidget(),
//             ),
//             Expanded(
//               child: TimerBanner(),
//             ),
//             Expanded(
//               child: AddSubCategoryScreen(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CategoryListWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//           height: 181,
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: FirestoreService.fetchCategories(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError || !snapshot.hasData) {
//                     return Center(
//                       child: Text('Error fetching categories'),
//                     );
//                   } else {
//                     List<Map<String, dynamic>> categories = snapshot.data!;
//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(height: 22),
//                               CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                   categories[index]['image'],
//                                 ),
//                                 radius: 45,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(8),
//                                 child: Text(
//                                   categories[index]['category'],
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FirestoreService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   static Future<List<Map<String, dynamic>>> fetchCategories() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection("Category").get();
//
//       List<Map<String, dynamic>> categories = [];
//       if (querySnapshot.docs.isNotEmpty) {
//         querySnapshot.docs.forEach((doc) {
//           categories.add({
//             'category': doc['category'],
//             'image': doc['image'],
//           });
//         });
//       }
//       return categories;
//     } catch (error) {
//       print('Error fetching categories: $error');
//       return [];
//     }
//   }
// }
// class BannerService {
//   static Future<List<String>> fetchBannerImages() async {
//     try {
//       QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection("Banner").get();
//
//       List<String> imageUrls = [];
//       if (querySnapshot.docs.isNotEmpty) {
//         querySnapshot.docs.forEach((doc) {
//           imageUrls.add(doc['image'] ?? '');
//         });
//       }
//       return imageUrls;
//     } catch (error) {
//       print('Error fetching banner images: $error');
//       return [];
//     }
//   }
// }
//
//
// class TimerBanner extends StatefulWidget {
//   @override
//   _TimerBannerState createState() => _TimerBannerState();
// }
//
// class _TimerBannerState extends State<TimerBanner> {
//   late Future<List<String>> _bannerImagesFuture;
//   late PageController _pageController;
//   late int _currentIndex;
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _bannerImagesFuture = BannerService.fetchBannerImages();
//     _pageController = PageController();
//     _currentIndex = 0;
//     _startAutoScroll();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _startAutoScroll() {
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       setState(() {
//         if (_currentIndex < _pageController.page!.toInt() + 1) {
//           _currentIndex++;
//         } else {
//           _currentIndex = 0;
//         }
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       child: FutureBuilder<List<String>>(
//         future: _bannerImagesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError || !snapshot.hasData) {
//             return Center(
//               child: Text('Error fetching banner images'),
//             );
//           } else {
//             final List<String> imageUrls = snapshot.data!;
//             return PageView.builder(
//               controller: _pageController,
//               itemCount: imageUrls.length,
//               itemBuilder: (context, index) {
//                 return Image.network(
//                   imageUrls[index],
//                   height: 100,
//                   fit: BoxFit.cover,
//                 );
//               },
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             );
//           }
//         },
//       ),
//
//
//     );
//   }
// }
//
//
// class AddSubCategoryScreen extends StatefulWidget {
//   const AddSubCategoryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AddSubCategoryScreen> createState() => _AddSubCategoryScreenState();
// }
//
// class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
//   // Your existing code
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.transparent,
//
//       body: Column(
//         children: [
//          Expanded(child: CategoryGrid())
//         ],
//       ),
//     );
//   }
// }
//
// class CategoryGrid extends StatefulWidget {
//   const CategoryGrid({Key? key}) : super(key: key);
//
//   @override
//   State<CategoryGrid> createState() => _CategoryGridState();
// }
//
// class _CategoryGridState extends State<CategoryGrid> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('SubCategories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const CircularProgressIndicator();
//         }
//
//         final subcategoryDocs = snapshot.data!.docs;
//
//         return GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 20,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: subcategoryDocs.length,
//           itemBuilder: (context, index) {
//             final subcategoryData = subcategoryDocs[index].data() as Map<String, dynamic>;
//
//             return InkWell(
//               onTap: () {
//                 // Handle item tap
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   color: Colors.black45,
//                   child: Column(
//                     children: [
//                       Card(
//                         elevation: 20,
//                         color: Colors.black,
//                         shadowColor: Colors.black,
//                         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(subcategoryData['image'],
//                          // fit: BoxFit.cover, // Adjust the fit as needed
//                         ),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(10),
//
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               //Image.network(subcategoryData['image'], height: 106, width: 100),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       ),
//                       Container(
//                         color: Colors.black87,
//                         width: double.infinity,
//                         height: 54,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                               subcategoryData['audio_name'] != null
//                                   ? (subcategoryData['audio_name'] as String).substring(0, 15) + '...' // Trims to 15 characters
//                                   : 'Unknown',
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//
//                     ],
//                   ),
//
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
