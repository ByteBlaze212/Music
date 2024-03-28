import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Use'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last Updated: January 1, 2024',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.0),
            _buildSectionTitle('Introduction'),
            _buildSectionContent(
                'These Terms of Use govern your use of the Music App. By accessing or using the app, you agree to be bound by these Terms of Use.'),
            SizedBox(height: 24.0),
            _buildSectionTitle('User Accounts'),
            _buildSectionContent(
                'You may need to create a user account to use certain features of the app. You are responsible for maintaining the confidentiality of your account credentials.'),
            SizedBox(height: 24.0),
            _buildSectionTitle('Content'),
            _buildSectionContent(
                'You may not upload, post, or transmit any content that violates the rights of others, is unlawful, or is otherwise objectionable.'),
            SizedBox(height: 24.0),
            _buildSectionTitle('Limitation of Liability'),
            _buildSectionContent(
                'We are not liable for any damages arising from your use of the app.'),
            SizedBox(height: 24.0),
            _buildSectionTitle('Changes to Terms'),
            _buildSectionContent(
                'We may update these Terms of Use from time to time. It is your responsibility to review these terms periodically for changes.'),
            SizedBox(height: 24.0),
            _buildSectionTitle('Contact Us'),
            _buildSectionContent(
                'If you have any questions about these Terms of Use, please contact us.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }
}


