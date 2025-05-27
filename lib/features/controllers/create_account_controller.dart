import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Store selected dropdown item (passed from the screen)
  final RxString selectedDropdownItem = ''.obs;

  void selectDropdownItem(String? value) {
    if (value != null) {
      selectedDropdownItem.value = value;
    }
  }

  void clearFields() {
    patientIdController.clear();
    passwordController.clear();
    selectedDropdownItem.value = '';
  }

  @override
  void onClose() {
    patientIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
