import 'package:flutter/material.dart';
import 'package:user_melo/HelpCenter.dart';
import 'package:user_melo/PlatformRules.dart';
import 'package:user_melo/PrivacyPolicy.dart';
import 'AboutScreen.dart';
import 'Terms&Use.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              buildSettingsItem(
                  context, "About", Icons.info_outline, () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutScreen()));
                // Action for Manage Notifications
              }),
              const SizedBox(height: 20),
              const Text(
                "Account Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              buildSettingsItem(
                  context, "Manage Notifications", Icons.notifications, () {
                // Action for Manage Notifications
              }),

              const SizedBox(height: 20),
              const Text(
                "Feedback & Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              buildSettingsItem(context, "Terms of Use", Icons.description,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TermsOfUseScreen()));
                  }),
              buildSettingsItem(context, "Privacy Policy", Icons.privacy_tip,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()));
                  }),
              buildSettingsItem(
                  context, "Platform Rules", Icons.rule, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlatformRulesScreen()));
              }),
              buildSettingsItem(context, "Help Center", Icons.help, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FaqScreen()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsItem(
      BuildContext context, String title, IconData icon, Function() onTap) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
