import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart';
import 'package:just_audio/just_audio.dart';

import 'package:uboho/utiils/constants/icons.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';
import 'package:uboho/service_backend/seizure_prediction/seizure_event_handler.dart';

class SeizureAlertDialog extends StatefulWidget {
  const SeizureAlertDialog({super.key});

  @override
  State<SeizureAlertDialog> createState() => _SeizureAlertDialogState();
}

class _SeizureAlertDialogState extends State<SeizureAlertDialog> {
  int _countdown = 30;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  bool _hasPlayed = false;
  bool _dismissedManually = false;

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Start countdown right away
    Future.microtask(() => _triggerFeedback()); // Trigger audio and vibration after UI begins rendering
  }

  Future<void> _triggerFeedback() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30000);
    }

    if (!_hasPlayed) {
      _hasPlayed = true;
      try {
        // Play audio without awaiting
        unawaited(
          _player.setAsset('assets/sounds/digital_clock.wav').then((_) {
            _player.play();
          }),
        );
      } catch (e) {
        debugPrint("Audio play error: $e");
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer?.cancel();
        if (!_dismissedManually) {
          SeizureEventHandler.handleSeizureEvent(); // Run async in background
        }
        if (mounted) Navigator.of(context).pop(); // Close immediately
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _dismissManually() async {
    _dismissedManually = true;
    _timer?.cancel();
    _player.stop();
    Vibration.cancel();

    await SeizureEventHandler.handleNoSeizureEvent();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Dialog(
            backgroundColor: UColors.backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        Expanded(
                          child: Text(
                            'Event Detected',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    const Text(
                      "We've detected unusual movement in your motion and rotation intensity. "
                          "Please decline if this is not an event; otherwise, your Emergency contact will be alerted.",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Decline',
                      onPressed: _dismissManually,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
