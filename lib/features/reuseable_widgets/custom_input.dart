import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utiils/constants/colors.dart';
import '../../utiils/constants/icons.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?>? onDropdownChanged;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedItem,
    this.onDropdownChanged,
    this.controller,
    this.readOnly = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDropdown) {
      final dropdownValue = widget.dropdownItems?.contains(widget.selectedItem) == true
          ? widget.selectedItem
          : null;

      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white24),
          color: UColors.boxHighlightColor,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            hint: Text(widget.hintText, style: const TextStyle(color: Colors.white70)),
            dropdownColor: UColors.backgroundColor,
            icon: SvgPicture.asset(
              UIcons.dropdownIcon,
              height: 5.5,
              width: 10.5,
            ),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            onChanged: widget.onDropdownChanged,
            items: widget.dropdownItems?.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      final bool isActive =
          _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);

      return SizedBox(
        height: 48,
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.isPassword ? _obscureText : false,
          readOnly: widget.readOnly,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: isActive ? Colors.transparent : UColors.boxHighlightColor,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: UColors.primaryColor),
            ),
          ),
        ),
      );
    }
  }
}
