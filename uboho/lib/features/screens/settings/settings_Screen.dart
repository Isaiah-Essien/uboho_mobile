import 'package:flutter/material.dart';

import '../../../utiils/constants/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: Center(
        child: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
