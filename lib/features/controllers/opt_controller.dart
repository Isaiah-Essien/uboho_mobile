// controllers/otp_controller.dart
import 'dart:async';
import 'package:get/get.dart';

class OTPController extends GetxController {
  final RxInt secondsLeft = 60.obs;
  late Timer _timer;
  String userEmail = '';

  void startCountdown() {
    secondsLeft.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void setEmail(String email) {
    userEmail = email;
  }

  void resendCode() {
    startCountdown();
    // Add resend code logic here
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
