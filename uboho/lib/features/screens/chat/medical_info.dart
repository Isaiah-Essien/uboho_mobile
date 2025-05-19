import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uboho/utiils/constants/colors.dart';

class MedicalInformationScreen extends StatelessWidget {
  const MedicalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar with Back Icon and Title
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
                      "Medical Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 58), // Reserve space to center the title
                ],
              ),
            ),

            // Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: const [
                    _InfoRow(label: "Name", value: "Mastou Oumarou"),
                    _DividerLine(),
                    _InfoRow(label: "Assigned Doctor", value: "Kingsley Budu"),
                    _DividerLine(),
                    _InfoRow(label: "Phone Number", value: "+250 790 139 525"),
                    _DividerLine(),
                    _InfoRow(label: "Doctor ID", value: "DID1234569876"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: UColors.dividerColor.withOpacity(0.5),
    );
  }
}
