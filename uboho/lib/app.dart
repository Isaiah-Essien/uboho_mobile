import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uboho/splash_screen.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/device/network_manager.dart';



class App extends StatelessWidget {
  const App({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Initialize AssetProvider

    return NetworkManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uboho',
        themeMode: ThemeMode.system,
        home: SplashScreen(),
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: UColors.getMaterialColor(UColors.primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}
