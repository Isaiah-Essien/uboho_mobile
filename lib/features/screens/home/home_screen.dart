import 'package:flutter/material.dart';
import '../../../utiils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
