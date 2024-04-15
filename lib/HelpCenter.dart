import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFaqItem(
              'How do I create a playlist?',
              'To create a playlist, go to the playlist section and click on the "Create Playlist" button. Then, give your playlist a name and add your favorite songs to it.',
            ),
            const Divider(),
            _buildFaqItem(
              'How can I search for a specific song?',
              'You can search for a specific song by using the search bar at the top of the app. Simply enter the name of the song you"re looking for, and the app will display relevant results.',
            ),
            const Divider(),

            _buildFaqItem(
              'Can I download songs for offline listening?',
              'Yes, you can download songs for offline listening. Simply click on the download button next to the song you want to download, and it will be saved to your device for offline playback.',
            ),
            const Divider(),
            _buildFaqItem(
              'How do I update my account information?',
              'To update your account information, go to the settings section and select "Account Settings." From there, you can update your name, email address, password, and other account details.',
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Contact Us',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ContactItem(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'mailto:support@meloapp.com',
              onTap: () {
                launchEmail('support@meloapp.com');
              },
            ),
            ContactItem(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: '+91 9639639633',
              onTap: () {
                launchPhone('+919639639633');
              },
            ),
            ContactItem(
              icon: Icons.location_on,
              title: 'Address',
              subtitle: 'Ahmedabad University, Ahmedabad, Gujarat',
              onTap: () {
                launchMap('Ahmedabad+University,+Ahmedabad,+Gujarat');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            answer,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Future<void> launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final url = emailLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    final url = phoneLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchMap(String query) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
class ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? mapQuery;
  final VoidCallback? onTap;

  const ContactItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.mapQuery,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
