import 'package:flutter/material.dart';

import '../../utiils/constants/colors.dart';

class LongLineFooter extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onTap;

  const LongLineFooter({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.white12),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: RichText(
            text: TextSpan(
              text: message,
              style: const TextStyle(color: Colors.white70),
              children: [
                TextSpan(
                  text: actionText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class FooterText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const FooterText({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: '$text ',
            style: const TextStyle(color: Colors.white54),
            children: [
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  color: UColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
