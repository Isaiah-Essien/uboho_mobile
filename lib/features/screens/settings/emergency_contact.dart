import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/features/reuseable_widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_emergency_contact.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  // The entire Firestore array:
  List<Map<String, dynamic>> _allContacts = [];

  // Just the one we render (always length 0 or 1)
  List<Map<String, dynamic>> emergencyContacts = [];

  DocumentReference? patientRef;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
  }

  Future<void> _loadEmergencyContacts() async {
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // find the patient doc
    final hospitals =
    await FirebaseFirestore.instance.collection('hospitals').get();
    for (final hospital in hospitals.docs) {
      final patients = hospital.reference.collection('patients');
      final query =
      await patients.where('authId', isEqualTo: uid).limit(1).get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        patientRef = doc.reference;

        // pull down the raw array
        final raw = doc.data()['emergencyContacts'] as List<dynamic>? ?? [];
        _allContacts = raw.cast<Map<String, dynamic>>();

        // pick or promote exactly one primary
        if (_allContacts.isEmpty) {
          emergencyContacts = [];
        } else {
          // if none flagged or multiple flagged, clear them and pick index 0
          var primaryIdx = _allContacts.indexWhere((c) => c['isPrimary'] == true);
          if (primaryIdx < 0 || _allContacts.where((c) => c['isPrimary'] == true).length > 1) {
            for (var i = 0; i < _allContacts.length; i++) {
              _allContacts[i]['isPrimary'] = (i == 0);
            }
            await patientRef!.update({'emergencyContacts': _allContacts});
            primaryIdx = 0;
          }
          emergencyContacts = [_allContacts[primaryIdx]];
        }
        break;
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _deleteContact(int index) async {
    if (patientRef == null) return;

    setState(() => _isLoading = true);

    // We always show exactly one, so find its position in _allContacts
    final toDelete = emergencyContacts[index];
    final origIdx =
    _allContacts.indexWhere((c) => mapEquals(c, toDelete));

    if (origIdx >= 0) {
      _allContacts.removeAt(origIdx);
      // write the trimmed array back
      await patientRef!.update({'emergencyContacts': _allContacts});
    }

    // now pick a new primary & display it
    if (_allContacts.isEmpty) {
      emergencyContacts = [];
    } else {
      for (var i = 0; i < _allContacts.length; i++) {
        _allContacts[i]['isPrimary'] = (i == 0);
      }
      await patientRef!.update({'emergencyContacts': _allContacts});
      emergencyContacts = [_allContacts[0]];
    }

    setState(() => _isLoading = false);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch dialer',backgroundColor: Colors.redAccent.withOpacity(0.5), colorText: Colors.white,duration: Duration(microseconds: 1500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: UColors.boxHighlightColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Emergency Contacts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
                      onPressed: () async {
                        await Get.to(const AddEmergencyContactScreen());
                        await _loadEmergencyContacts();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: _isLoading
                  ? const Center(
                child: Text(
                  'Your emergency contacts are loading...',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : emergencyContacts.isEmpty
                  ? const Center(
                child: Text(
                  'You have no emergency contact. \n Click on the Plus sign(+) to add one...',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  final name = contact['name'] as String;
                  final isEmpty = name.isEmpty;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: UColors.boxHighlightColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Header: avatar, name, delete
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: UColors.backgroundColor,
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.person,
                                      size: 20,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    isEmpty ? 'Empty Contact' : name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      LucideIcons.trash2,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      _deleteContact(index),
                                ),
                              ],
                            ),
                          ),

                          // Details + Call button
                          if (!isEmpty) ...[
                            const _DividerLine(),
                            _InfoRow(
                                label: "Relation",
                                value: contact['relation'] ?? ''),
                            const _DividerLine(),
                            _InfoRow(
                                label: "Phone",
                                value:
                                "${contact['countryCode']} ${contact['phone']}"),
                            const _DividerLine(),
                            _InfoRow(
                                label: "Email",
                                value: contact['email']),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: PrimaryButton(
                                text: "Call $name",
                                onPressed: () => _makePhoneCall(
                                    "${contact['countryCode']}${contact['phone']}"),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  );
                },
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
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
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
