// controllers/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<String> messages = <String>[].obs;

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      messages.add(text);
      messageController.clear();
    }
  }
}
