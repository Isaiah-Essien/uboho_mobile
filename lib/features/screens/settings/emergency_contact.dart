import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';

import 'add_emergency_contact.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                  const Expanded(
                    child: Text(
                      'Emergency Contact',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: ()=>Get.to(AddEmergencyContactScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Emergency Contact Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: UColors.boxHighlightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Header Row with name and delete icon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                        Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: UColors.backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                          // border: Border.all(color: UColors.dividerColor.withOpacity(0.4), width: 1),
                        ),
                        child: const Icon(Icons.person, size: 20, color: Colors.white),
                      ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Laureen Balongo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                            onPressed: () {
                              // TODO: delete action
                            },
                          ),
                        ],
                      ),
                    ),

                    const _DividerLine(),

                    // Information
                    const _InfoRow(label: "Relation", value: "Sister"),
                    const _DividerLine(),
                    const _InfoRow(label: "Phone", value: "+250 790 139 525"),
                    const _DividerLine(),
                    const _InfoRow(label: "Email", value: "laureenbalongo@gmail.com"),

                    const SizedBox(height: 20),

                    // Call Button using PrimaryButton widget
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        text: "Call Laureen",
                        onPressed: () {
                          // TODO: call function
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
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

// Reused row styling for label + value
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
          Text(label, style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

// Divider styled to match your existing UI
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
