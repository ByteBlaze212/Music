import 'package:flutter/material.dart';

import 'color.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: lr,
        title: Text('Search',style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
