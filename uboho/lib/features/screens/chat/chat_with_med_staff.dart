import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';

class ChatWithMedicalStaffScreen extends StatefulWidget {
  const ChatWithMedicalStaffScreen({super.key});

  @override
  State<ChatWithMedicalStaffScreen> createState() => _ChatWithMedicalStaffScreenState();
}

class _ChatWithMedicalStaffScreenState extends State<ChatWithMedicalStaffScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'time': DateFormat('hh:mm a').format(DateTime.now()),
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Chat with a medical staff',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    // Received message hardcoded
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: UColors.backgroundColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: UColors.inputInactiveColor,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(UIcons.uVector),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: UColors.boxHighlightColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    "Hi Martha, let me take a look at your activity from my end!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "01:04 PM",
                                  style: TextStyle(fontSize: 10, color: Colors.white38),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Sent messages
                    final message = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: UColors.primaryColor.withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    message['text'] ?? '',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message['time'] ?? '',
                                  style: const TextStyle(fontSize: 10, color: Colors.white38),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage("assets/images/sender.png"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // Input Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: UColors.inputInactiveColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Message Uboho",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.paperclip, color: UColors.inputInactiveColor),
                      onPressed: () {
                        // Handle attachment (logic to add later)
                      },
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: UColors.primaryColor,
                        ),
                        child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
