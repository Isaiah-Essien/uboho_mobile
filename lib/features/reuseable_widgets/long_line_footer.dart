import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utiils/constants/colors.dart';

class FooterText extends StatelessWidget {
  final String fullText;
  final Map<String, VoidCallback> links;

  const FooterText({
    super.key,
    required this.fullText,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    String remainingText = fullText;

    links.forEach((linkText, onTap) {
      final index = remainingText.indexOf(linkText);
      if (index >= 0) {
        // Add plain text before the link
        if (index > 0) {
          spans.add(TextSpan(text: remainingText.substring(0, index)));
        }

        // Add the clickable link text
        spans.add(
          TextSpan(
            text: linkText,
            style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.normal, // Not bold
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        );

        // Remove processed part from the string
        remainingText = remainingText.substring(index + linkText.length);
      }
    });

    // Add any remaining plain text
    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText));
    }

    return Column(
      children: [
        const Divider(color: UColors.footerWithTextDividerColor),
        const SizedBox(height: 10),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 12),
              children: spans,
            ),
          ),
        ),
      ],
    );
  }
}
