import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_melo/color.dart';
import 'package:user_melo/playlist.dart';

import 'SettingScreen.dart';
import 'UserInfoScreen.dart';
import 'navigationbar.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [PBlue, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationHome(selectedIndex: 0,),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        'Account',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const CircleAvatar(
                        backgroundColor:
                        Colors.grey, // Placeholder for user profile picture
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  buildAccountCard(
                    title: 'My Account',
                    icon: Icons.account_box,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserInfoScreen()));
                    },
                  ),
                  buildAccountCard(
                    title: 'My WishList',
                    icon: Icons.favorite,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LikedSongsWidget()));
                    },
                  ),
                  buildAccountCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                    },
                  ),
                  buildAccountCard(
                    title: 'Logout',
                    icon: Icons.logout,
                    onTap: () {
                      // FirebaseAuth.instance.signOut();
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                      //       (route) => false,
                      // );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAccountCard(
      {required String title,
        required IconData icon,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white54,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(icon),
            ],
          ),
        ),
      ),

    );
  }
}
