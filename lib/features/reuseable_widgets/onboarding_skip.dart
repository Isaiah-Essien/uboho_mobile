import 'package:flutter/material.dart';
import '../../utiils/constants/colors.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const SkipButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.chevron_right, // default to '>'
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UColors.boxHighlightColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
