// widgets/overlay_profile_image.dart
import 'package:flutter/material.dart';

class OverlayProfileImage extends StatelessWidget {
  final String imagePath;
  final double left;
  final double bottom;

  const OverlayProfileImage({
    super.key,
    required this.imagePath,
    this.left = 30,
    this.bottom = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
