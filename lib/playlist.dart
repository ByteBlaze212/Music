import 'package:flutter/material.dart';

import 'color.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: lr,
        title: Text('Playlist',style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
