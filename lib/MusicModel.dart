import 'package:cloud_firestore/cloud_firestore.dart';

class MusicModel {
  final String id;
  final String image;
  final String category;
  final String lyrics;
  final String songName;
  // final int audioDuration; // Keep it as String
  final String songURL;
  final String singerName;

  MusicModel({
    required this.id,
    required this.category,
    required this.image,
    required this.lyrics,
    required this.songName,
    // required this.audioDuration,
    required this.songURL,
    required this.singerName,
  });

  factory MusicModel.fromSnapshot(DocumentSnapshot snapshot) {
    return MusicModel(
      id: snapshot.id,
      category: snapshot['category'],
      image: snapshot['image'],
      songName: snapshot['audio_name'],
      // audioDuration: snapshot['duration'], // Keep it as String
      songURL: snapshot['audio_url'],
      singerName: snapshot['singer'],
      lyrics: snapshot['lyrics'],
    );
  }

  // Static method to create an empty instance of MusicModel
  static MusicModel empty() {
    return MusicModel(
      id: '',
      category: '',
      lyrics: '',
      image: '',
      songName: '',
      // audioDuration: 0,
      songURL: '',
      singerName: '',
    );
  }
}
