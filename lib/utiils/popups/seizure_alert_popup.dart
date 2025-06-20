import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uboho/utiils/constants/icons.dart';
import '../../../utiils/constants/colors.dart';
import '../../features/reuseable_widgets/primary_button.dart';
class SeizureAlertDialog extends StatefulWidget {
  const SeizureAlertDialog({super.key});

  @override
  State<SeizureAlertDialog> createState() => _SeizureAlertDialogState();
}

class _SeizureAlertDialogState extends State<SeizureAlertDialog> {
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer?.cancel();
        if (mounted) Navigator.of(context).pop(); // Auto dismiss
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _dismissManually() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: UColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon with red rectangle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB52B42),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        UIcons.whiteUVector,
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Epilepsy Detected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$_countdown Secs',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              const Divider(color: Colors.white24),

              const SizedBox(height: 8),

              // Description Text
              const Text(
                "We've detected unusual movement in your motion and rotation intensity. "
                    "Please let us know if this is a false alert to help us improve our system.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Decline Button
              PrimaryButton(
                text: 'Decline',
                onPressed: _dismissManually,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
