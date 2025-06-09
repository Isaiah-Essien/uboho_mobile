import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountController extends GetxController {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Nullable to support default dropdown hint
  final RxnString selectedDropdownItem = RxnString();

  final RxList<String> hospitals = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHospitalNames();
  }

  void fetchHospitalNames() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('hospitals').get();

      final names = querySnapshot.docs
          .map((doc) => doc['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      hospitals.assignAll(names);
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }

  void selectDropdownItem(String? value) {
    selectedDropdownItem.value = value;
  }

  void clearFields() {
    patientIdController.clear();
    passwordController.clear();
    selectedDropdownItem.value = null;
  }

  @override
  void onClose() {
    patientIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
