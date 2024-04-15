import 'package:flutter/material.dart';

class PlatformRulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Rules'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platform Rules',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.0),
            _buildRuleItem('Respect Others', 'Treat other users with respect and refrain from posting offensive or harmful content.'),
            _buildRuleItem('No Spamming', 'Avoid excessive posting of content or repetitive messages.'),
            _buildRuleItem('Follow Guidelines', 'Follow all community guidelines and rules set forth by the platform.'),
            _buildRuleItem('No Illegal Activities', 'Do not engage in any illegal activities or promote illegal content.'),
            _buildRuleItem('Protect Privacy', 'Respect the privacy of others and refrain from sharing personal information without consent.'),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

