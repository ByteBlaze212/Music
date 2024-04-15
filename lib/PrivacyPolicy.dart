import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildPolicyPoint(
              'We collect personal information such as your name, email address, and location to provide personalized services and improve user experience.',
            ),
            _buildPolicyPoint(
              'We may use cookies and similar technologies to analyze trends, administer the website, track users’ movements around the website, and gather demographic information.',
            ),
            _buildPolicyPoint(
              'Your personal information may be shared with third-party service providers to facilitate our services and enhance functionality.',
            ),
            _buildPolicyPoint(
              'We may disclose personal information when required by law or to protect our rights and interests.',
            ),
            _buildPolicyPoint(
              'We take appropriate security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information.',
            ),
            _buildPolicyPoint(
              'By using our app, you consent to the collection, use, and disclosure of your personal information as described in this Privacy Policy.',
            ),
            _buildPolicyPoint(
              'This Privacy Policy is effective as of [Date]. We may update or modify this policy at any time without prior notice.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyPoint(String point) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            size: 10.0,
            color: Colors.black,
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              point,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

