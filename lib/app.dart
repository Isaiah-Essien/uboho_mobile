import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uboho/features/screens/onboarding/onboarding_screen.dart';
import 'package:uboho/service_backend/seizure_prediction/global_seizure_service.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/device/network_manager.dart';
import 'package:uboho/utiils/navigations/main_nav.dart'; // import main nav

class App extends StatelessWidget {
  const App({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Start the seizure monitoring service globally
    SeizureMonitorService.instance.initialize(navigatorKey);

    final currentUser = FirebaseAuth.instance.currentUser;

    // TODO: Add a custom splash screen widget here before routing home

    return NetworkManager(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uboho',
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: currentUser != null ? const MainNavigation() : OnboardingScreen(),
        theme: ThemeData(
          primarySwatch: UColors.getMaterialColor(UColors.primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Gilmer',
        ),
      ),
    );
  }
}
