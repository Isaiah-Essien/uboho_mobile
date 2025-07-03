import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uboho/features/screens/onboarding/onboarding_screen.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/navigations/main_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeUController;
  late AnimationController _fadeUbohoController;

  late Animation<double> _fadeUAnimation;
  late Animation<double> _fadeUbohoAnimation;

  bool showUboho = false;

  @override
  void initState() {
    super.initState();

    _fadeUController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeUbohoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeUAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _fadeUController,
      curve: Curves.easeOut,
    ));

    _fadeUbohoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _fadeUbohoController,
      curve: Curves.easeIn,
    ));

    // Step 1: Delay, then fade out U
    Future.delayed(const Duration(milliseconds: 2500), () {
      _fadeUController.forward();
    });

    // Step 2: Show Uboho after U disappears
    _fadeUController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => showUboho = true);
        _fadeUbohoController.forward();
      }
    });

    // Step 3: Navigate after full sequence based on login status
    Future.delayed(const Duration(seconds: 7), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offAll(() => const MainNavigation());
      } else {
        Get.offAll(() => OnboardingScreen());
      }
    });
  }

  @override
  void dispose() {
    _fadeUController.dispose();
    _fadeUbohoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fading U
            AnimatedBuilder(
              animation: _fadeUAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeUAnimation.value,
                  child: Image.asset(
                    'assets/logos/u_vector_img.png',
                    height: 64,
                    width: 64,
                  ),
                );
              },
            ),

            const SizedBox(width: 12),

            // Fade-in Uboho
            AnimatedBuilder(
              animation: _fadeUbohoAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeUbohoAnimation.value,
                  child: showUboho
                      ? Image.asset(
                    'assets/logos/primary.png',
                    height: 60,
                  )
                      : const SizedBox(width: 64),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
