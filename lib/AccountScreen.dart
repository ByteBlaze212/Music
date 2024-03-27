import 'package:flutter/material.dart';

import 'color.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lr,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Your Profile',style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
