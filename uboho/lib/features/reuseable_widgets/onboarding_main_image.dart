// widgets/main_image_with_decoration.dart
import 'package:flutter/material.dart';

class MainImageWithDecoration extends StatelessWidget {
  final String imagePath;

  const MainImageWithDecoration({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 382,
      height: 382,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
