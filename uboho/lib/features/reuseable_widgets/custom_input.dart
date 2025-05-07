import 'package:flutter/material.dart';
import '../../utiils/constants/colors.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final IconData? suffixIcon;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    required this.controller,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _focusNode.hasFocus || widget.controller.text.isNotEmpty;

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      obscureText: widget.isPassword,
      readOnly: widget.isDropdown || widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: isActive ? Colors.transparent : UColors.inputInactiveColor,
        hintStyle: const TextStyle(color: Colors.white70),
        suffixIcon: Icon(
          widget.suffixIcon ??
              (widget.isPassword
                  ? Icons.visibility_off
                  : widget.isDropdown
                  ? Icons.arrow_drop_down
                  : null),
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: UColors.primaryColor),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
