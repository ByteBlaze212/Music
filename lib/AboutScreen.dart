import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70.0,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.music_note,
                size: 50.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Melo',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Version: 9.5.1',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Developer: Yogin Anil',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'This is a music app that allows you to listen to your favorite songs, create playlists, and discover new music.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

