import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';
import 'package:uboho/service_backend/settiings_logics/profile_picture_service.dart';

class ChatWithMedicalStaffScreen extends StatefulWidget {
  const ChatWithMedicalStaffScreen({super.key});

  @override
  State<ChatWithMedicalStaffScreen> createState() => _ChatWithMedicalStaffScreenState();
}

class _ChatWithMedicalStaffScreenState extends State<ChatWithMedicalStaffScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ProfileImageService _imageService = ProfileImageService();

  String? profileImageUrl;
  bool _isLoading = true;

  late String conversationId;
  late String patientId;
  late String adminId;
  late String patientName;
  late String hospitalId;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _initializeChat();
  }

  Future<void> _loadProfileImage() async {
    final url = await _imageService.fetchProfileImageUrl();
    if (url != null) {
      setState(() => profileImageUrl = url);
    }
  }

  Future<void> _initializeChat() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final uid = currentUser.uid;

    final hospitalsSnap = await FirebaseFirestore.instance.collection('hospitals').get();
    for (final hospitalDoc in hospitalsSnap.docs) {
      final hospitalRef = hospitalDoc.reference;
      final patientSnap = await hospitalRef
          .collection('patients')
          .where('authId', isEqualTo: uid)
          .limit(1)
          .get();

      if (patientSnap.docs.isNotEmpty) {
        final patientDoc = patientSnap.docs.first;
        hospitalId = hospitalRef.id;
        patientId = patientDoc.id;
        patientName = patientDoc['name'] ?? '';

        final convSnap = await hospitalRef.collection('conversations').get();
        for (final doc in convSnap.docs) {
          final participants = List<String>.from(doc['participants'] ?? []);
          if (!participants.contains(patientId)) continue;

          conversationId = doc.id;
          final parts = conversationId.split('_');
          if (parts.length == 2) {
            patientId = parts[0];
            adminId = parts[1];
          }

          await hospitalRef
              .collection('conversations')
              .doc(conversationId)
              .update({'unreadCount.$patientId': 0});

          setState(() => _isLoading = false);
          return;
        }
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || conversationId.isEmpty) return;

    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);

    _messageController.clear();

    final docRef = FirebaseFirestore.instance
        .collection('hospitals')
        .doc(hospitalId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();

    await docRef.set({
      'text': text,
      'timestamp': timestamp,
      'senderId': patientId,
      'senderName': patientName,
      'type': 'text',
    });

    await FirebaseFirestore.instance
        .collection('hospitals')
        .doc(hospitalId)
        .collection('conversations')
        .doc(conversationId)
        .update({
      'lastMessage': text,
      'lastMessageTime': timestamp,
      'unreadCount.$adminId': FieldValue.increment(1),
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Chat with a medical staff",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 58),
                ],
              ),
            ),

            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('hospitals')
                      .doc(hospitalId)
                      .collection('conversations')
                      .doc(conversationId)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final isMe = data['senderId'] == patientId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: UColors.backgroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: UColors.inputInactiveColor,
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(UIcons.uVector),
                                  ),
                                ),
                              if (!isMe) const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? UColors.primaryColor.withOpacity(0.13)
                                            : UColors.boxHighlightColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(data['text'] ?? '', style: const TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM d, HH:mm').format((data['timestamp'] as Timestamp).toDate()),
                                      style: const TextStyle(fontSize: 10, color: Colors.white38),
                                    ),
                                  ],
                                ),
                              ),
                              if (isMe) const SizedBox(width: 8),
                              if (isMe)
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white24,
                                  backgroundImage: profileImageUrl != null
                                      ? CachedNetworkImageProvider(profileImageUrl!)
                                      : null,
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            // Message input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: UColors.inputInactiveColor, width: 1.5),
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
                      onPressed: () {}, // Still empty unless used for file support later
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(UColors.primaryColor),
                        shape: MaterialStateProperty.all(const CircleBorder()),
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
