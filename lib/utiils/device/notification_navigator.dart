import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/features/screens/settings/emergency_contact.dart';
import 'package:uboho/features/screens/settings/medical_info.dart';
import 'package:uboho/features/screens/settings/add_emergency_contact.dart';

import '../../features/screens/settings/settings_Screen.dart';

class NotificationNavigator {
  static void navigateToTarget(String screen, {Map<String, dynamic>? arguments}) {
    switch (screen) {
      case 'SettingsScreen':
        Get.to(() => const SettingsScreen(), arguments: arguments);
        break;

      case 'EmergencyContactScreen':
        Get.to(() => EmergencyContactScreen(), arguments: arguments);
        break;

      case 'MedicalInformationScreen':
        Get.to(() => const MedicalInformationScreen(), arguments: arguments);
        break;

      case 'AddEmergencyContactScreen':
        Get.to(() => const AddEmergencyContactScreen(), arguments: arguments);
        break;

      default:
        debugPrint('Unknown target screen: $screen');
        break;
    }
  }
}
