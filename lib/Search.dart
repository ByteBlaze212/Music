import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_melo/MusicModel.dart';
import 'package:user_melo/player.dart';

import 'color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode _focusNode;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<MusicModel> productItem = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Remove focus from text field when screen is first loaded
    _focusNode.unfocus();
    searchController.addListener(_onSearchInputChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchInputChange() {
    final newQuery = searchController.text;
    if (query != newQuery) {
      setState(() {
        query = newQuery;
        isSearching = newQuery.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            focusNode: _focusNode,
            controller: searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  searchController.clear();
                },
              )
                  : null,
              hintText: 'Search Songs',
              hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ),
      body: isSearching
          ? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("SubCategories")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No search results found.",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.docs;
          productItem =
              data.map((e) => MusicModel.fromSnapshot(e)).toList();

          if (query.isNotEmpty) {
            productItem = productItem.where((element) {
              final lowerCaseQuery = query.toLowerCase();
              return element.songName
                  .toLowerCase()
                  .contains(lowerCaseQuery);
            }).toList();
          }

          if (productItem.isEmpty) {
            return Center(
              child:  Text(
                "No search results found.",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: productItem.length,
            itemBuilder: (context, index) {
              final product = productItem[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerScreenController(
                        musicList: productItem,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 0.3,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Image.network(
                            product.image,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.songName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.singerName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
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
      )
          : Center(
        child: Text(
          "Search for Songs ...",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
