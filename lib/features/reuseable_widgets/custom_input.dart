import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utiils/constants/colors.dart';
import '../../utiils/constants/icons.dart';

/// What kind of validation to apply.
enum InputValidationType { none, email, password, phone }

class CustomInputField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?>? onDropdownChanged;
  final TextEditingController? controller;
  final bool readOnly;
  final InputValidationType validationType;

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedItem,
    this.onDropdownChanged,
    this.controller,
    this.readOnly = false,
    this.validationType = InputValidationType.none,
  }) : super(key: key);

  @override
  CustomInputFieldState createState() => CustomInputFieldState();
}

class CustomInputFieldState extends State<CustomInputField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocus);
  bool _obscureText = true;
  String? _errorText;

  void _onFocus() {
    if (!_focusNode.hasFocus) _validate();
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Public API for external validation calls
  bool validate() {
    _validate();
    return _errorText == null;
  }

  void _validate() {
    String? error;
    final text = _controller.text.trim();

    if (widget.isDropdown) {
      if (widget.selectedItem == null || widget.selectedItem!.isEmpty) {
        error = '${widget.hintText} cannot be empty';
      }
    } else {
      if (text.isEmpty) {
        error = '${widget.hintText} cannot be empty';
      } else {
        switch (widget.validationType) {
          case InputValidationType.email:
            final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!re.hasMatch(text)) error = 'Please enter a valid email';
            break;
          case InputValidationType.password:
            final re = RegExp(
                r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*]).{8,}$');
            if (!re.hasMatch(text)) {
              error =
              'Password ≥8 chars, 1 uppercase, 1 digit & 1 special';
            }
            break;
          case InputValidationType.phone:
            final re = RegExp(r'^\d+$');
            if (!re.hasMatch(text)) error = 'Phone must be digits only';
            break;
          case InputValidationType.none:
            break;
        }
      }
    }

    if (error != _errorText) {
      setState(() => _errorText = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _errorText != null;

    // Borders
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: hasError ? Colors.redAccent : Colors.white24),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: hasError ? Colors.redAccent : UColors.primaryColor),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Colors.redAccent),
    );

    if (widget.isDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: hasError ? Colors.redAccent : Colors.white24),
              color: UColors.boxHighlightColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.dropdownItems?.contains(widget.selectedItem) == true
                    ? widget.selectedItem
                    : null,
                hint: Text(widget.hintText,
                    style: const TextStyle(color: Colors.white70)),
                dropdownColor: UColors.backgroundColor,
                icon: SvgPicture.asset(
                  UIcons.dropdownIcon,
                  height: 5.5,
                  width: 10.5,
                ),
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                onChanged: widget.onDropdownChanged,
                items: widget.dropdownItems
                    ?.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
                    .toList(),
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 4),
            Text(_errorText!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ]
        ],
      );
    }

    final bool isActive = _focusNode.hasFocus || _controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _obscureText : false,
            readOnly: widget.readOnly,
            style: const TextStyle(color: Colors.white),

            // *** NEW: numeric keyboard for phone, text otherwise
            keyboardType: widget.validationType == InputValidationType.phone
                ? TextInputType.number
                : TextInputType.text,

            // *** NEW: dismiss keyboard on Enter/Done
            onSubmitted: (_) => _focusNode.unfocus(),

            // keep your validation on editing complete
            onEditingComplete: _validate,

            decoration: InputDecoration(
              filled: true,
              fillColor: isActive
                  ? Colors.transparent
                  : UColors.boxHighlightColor,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: baseBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
                  : null,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(_errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ]
      ],
    );
  }
}
