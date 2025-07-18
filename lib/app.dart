import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/service_backend/seizure_prediction/global_seizure_service.dart';
import 'package:uboho/splash_screen.dart';
import 'package:uboho/utiils/constants/colors.dart';

class App extends StatelessWidget {
  const App({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Start the seizure monitoring service globally
    SeizureMonitorService.instance.initialize(navigatorKey);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uboho',
      themeMode: ThemeMode.system,
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      theme: ThemeData(
        primarySwatch: UColors.getMaterialColor(UColors.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Gilmer',
      ),
    );
  }
}
