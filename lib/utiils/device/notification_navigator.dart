import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../features/screens/settings/emergency_contact.dart';
import '../../features/screens/settings/medical_info.dart';
import '../../features/screens/settings/add_emergency_contact.dart';
import '../../features/screens/settings/settings_Screen.dart';

class NotificationNavigator {
  static void navigateFromNotification({
    required String route,
    Map<String, dynamic>? arguments,
  }) {
    Widget? targetScreen;

    switch (route) {
      case 'settings':
        targetScreen = const SettingsScreen();
        break;
      case 'emergency-contact':
        targetScreen = const EmergencyContactScreen();
        break;
      case 'medical-info':
        targetScreen = const MedicalInformationScreen();
        break;
      case 'add-emergency-contact':
        targetScreen = const AddEmergencyContactScreen();
        break;
      default:
        Get.snackbar(
          'Navigation Error',
          'Unknown destination: $route',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
    }

    if (targetScreen != null) {
      Get.to(() => targetScreen, arguments: arguments);
    }
  }
}
