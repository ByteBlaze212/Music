// category_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String genre;
  final String image;

  CategoryModel({required this.genre, required this.image});

  factory CategoryModel.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return CategoryModel(
      genre: data['category'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
