import 'package:flutter/material.dart';
import 'package:user_melo/AccountScreen.dart';
import 'package:user_melo/Search.dart';
import 'package:user_melo/mainpage.dart';
import 'package:user_melo/player.dart';
import 'package:user_melo/playlist.dart';
import'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'color.dart';
import 'homePage.dart';

import 'package:flutter/material.dart';
import 'package:user_melo/AccountScreen.dart';
import 'package:user_melo/Search.dart';
import 'package:user_melo/mainpage.dart';
import 'package:user_melo/player.dart';
import 'package:user_melo/playlist.dart';
import'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'color.dart';
import 'homePage.dart';

class BottomNavigationHome extends StatefulWidget {
  int selectedIndex;
  BottomNavigationHome({super.key, required this.selectedIndex});

  @override
  State<BottomNavigationHome> createState() => _BottomNavigationHomeState();
}

class _BottomNavigationHomeState extends State<BottomNavigationHome> {
  List<Widget>widgetspage = [
    HomePage1(),
    const PlayList(),
    const Search(),
    const AccountScreen(),
  ];

  Future<bool>_onWillPop () async{
    if(widget.selectedIndex==0){
      return true;
    }else{
      setState((){
        widget.selectedIndex=0;
      });
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Register the callback for back button press
      child: Scaffold(
        backgroundColor: Colors.black,

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: lr,
          currentIndex: widget.selectedIndex!.toInt(),
          onTap: (value) {
            setState(() {
              widget.selectedIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              label: "Home",
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: lr,
              label: "PlayList",
              icon: Icon(
                Icons.playlist_add_check,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: lr,
              label: "Search",
              icon: Icon(Icons.search_outlined),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ],
        ),
        body: widgetspage.elementAt(widget.selectedIndex!.toInt()),
      ),
    );

  }
}




// class BottomNavigationHome extends StatefulWidget {
//   int selectedIndex;
//   BottomNavigationHome({Key? key, required this.selectedIndex}) : super(key: key);
//
//   @override
//   State<BottomNavigationHome> createState() => _BottomNavigationHomeState();
// }
//
// class _BottomNavigationHomeState extends State<BottomNavigationHome> {
//   late PlayerBottomBar _playerBottomBar;
//   late List<Widget> widgetspage;
//
//   @override
//   void initState() {
//     super.initState();
//     _playerBottomBar = PlayerBottomBar(cancelCallback: _cancel);
//     widgetspage = [
//       HomePage1(),
//       const PlayList(),
//       const Search(),
//       const AccountScreen(),
//     ];
//   }
//
//   void _cancel() {
//     setState(() {
//       widget.selectedIndex = 0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop, // Register the callback for back button press
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         bottomNavigationBar: BottomNavigationBar(
//           selectedItemColor: Colors.white,
//           unselectedItemColor: lr,
//           currentIndex: widget.selectedIndex,
//           onTap: (value) {
//             setState(() {
//               widget.selectedIndex = value;
//             });
//           },
//           items: const [
//             BottomNavigationBarItem(
//               backgroundColor: Colors.black,
//               label: "Home",
//               icon: Icon(
//                 Icons.home,
//               ),
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: lr,
//               label: "PlayList",
//               icon: Icon(
//                 Icons.playlist_add_check,
//               ),
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: lr,
//               label: "Search",
//               icon: Icon(Icons.search_outlined),
//             ),
//             BottomNavigationBarItem(
//               label: "Profile",
//               backgroundColor: Colors.black,
//               icon: Icon(
//                 Icons.person_outline_outlined,
//               ),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             widgetspage.elementAt(widget.selectedIndex),
//             if (widget.selectedIndex == 0) Positioned(bottom: 0, left: 0, right: 0, child: _playerBottomBar),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     if (widget.selectedIndex == 0) {
//       return true;
//     } else {
//       setState(() {
//         widget.selectedIndex = 0;
//       });
//       return false;
//     }
//   }
// }
//
//
//
//
// class PlayerScreen extends StatefulWidget {
//   @override
//   _PlayerScreenState createState() => _PlayerScreenState();
// }
//
// class _PlayerScreenState extends State<PlayerScreen> {
//   bool _showPlayerBottomBar = true;
//
//   void _cancel() {
//     setState(() {
//       _showPlayerBottomBar = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Player Screen'),
//       ),
//       body: Column(
//         children: <Widget>[
//           // Your player content here
//           Expanded(
//             child: Center(
//               child: Text('Your player content'),
//             ),
//           ),
//           if (_showPlayerBottomBar) PlayerBottomBar(cancelCallback: _cancel),
//         ],
//       ),
//     );
//   }
// }
//
// class PlayerBottomBar extends StatelessWidget {
//   final VoidCallback cancelCallback;
//
//   PlayerBottomBar({required this.cancelCallback});
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.skip_previous),
//             onPressed: () {
//     if (widget.currentIndex > 0) {
//     widget.onIndexChanged(widget.currentIndex - 1);
//     widget.audioPlayer.stop();
//     widget.audioPlayer.seek(Duration.zero);
//     widget.audioPlayer.setUrl(widget.musicList[widget.currentIndex].songURL);
//     widget.audioPlayer.play();
//     }
//     },
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.play_arrow),
//             onPressed: () {
//               // Handle previous button tap
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.skip_next),
//             onPressed: () {
//               // Handle next button tap
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.cancel),
//             onPressed: cancelCallback,
//           ),
//         ],
//       ),
//     );
//   }
// }
