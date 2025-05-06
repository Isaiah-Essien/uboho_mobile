import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/icons.dart';


class ErrorAlert extends StatefulWidget {
  final String message;

  const ErrorAlert({
    super.key,
    required this.message,
  });

  @override
  _ErrorAlertState createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return _buildAlert(
      const Color.fromRGBO(241, 192, 190, 1.0).withOpacity(0.4),
      const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
      _buildGlassyIcon(UIcons.errorAlert),
      widget.message,
    );
  }

  Widget _buildGlassyIcon(String iconPath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromRGBO(241, 192, 190, 1.0).withOpacity(0.4),
            border: Border.all(
              color: const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
        SvgPicture.asset(
          iconPath,
          width: 55,
          height: 55,
        ),
      ],
    );
  }

  Widget _buildAlert(
      Color startColor, Color endColor, Widget icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Error message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 20, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarningAlert extends StatefulWidget {
  final String message;

  const WarningAlert({
    super.key,
    required this.message,
  });

  @override
  _WarningAlertState createState() => _WarningAlertState();
}

class _WarningAlertState extends State<WarningAlert> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return _buildAlert(
      const Color.fromRGBO(238, 223, 196, 1.0).withOpacity(0.4),
      const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
      _buildGlassyIcon(UIcons.warningAlert),
      widget.message,
    );
  }

  Widget _buildGlassyIcon(String iconPath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromRGBO(238, 223, 196, 1.0).withOpacity(0.4),
            border: Border.all(
              color: const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
        SvgPicture.asset(
          iconPath,
          width: 55,
          height: 55,
        ),
      ],
    );
  }

  Widget _buildAlert(
      Color startColor, Color endColor, Widget icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Warning message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 20, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessAlert extends StatefulWidget {
  final String message;

  const SuccessAlert({
    super.key,
    required this.message,
  });

  @override
  _SuccessAlertState createState() => _SuccessAlertState();
}

class _SuccessAlertState extends State<SuccessAlert> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return _buildAlert(
      const Color.fromRGBO(193, 238, 208, 1.0).withOpacity(0.4),
      const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
      _buildGlassyIcon(UIcons.successAlert),
      widget.message,
    );
  }

  Widget _buildGlassyIcon(String iconPath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromRGBO(193, 238, 208, 1.0).withOpacity(0.4),
            border: Border.all(
              color: const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
        SvgPicture.asset(
          iconPath,
          width: 55,
          height: 55,
        ),
      ],
    );
  }

  Widget _buildAlert(
      Color startColor, Color endColor, Widget icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Success message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 20, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InformativeAlert extends StatefulWidget {
  final String message;

  const InformativeAlert({
    super.key,
    required this.message,
  });

  @override
  _InformativeAlertState createState() => _InformativeAlertState();
}

class _InformativeAlertState extends State<InformativeAlert> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return _buildAlert(
      const Color.fromRGBO(226, 205, 241, 1.0).withOpacity(0.4),
      const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
      _buildGlassyIcon(UIcons.InformativeAlert),
      widget.message,
    );
  }

  Widget _buildGlassyIcon(String iconPath) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromRGBO(226, 205, 241, 1.0).withOpacity(0.4),
            border: Border.all(
              color: const Color.fromRGBO(230, 229, 243, 1.0).withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
        SvgPicture.asset(
          iconPath,
          width: 55,
          height: 55,
        ),
      ],
    );
  }

  Widget _buildAlert(
      Color startColor, Color endColor, Widget icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Informative message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: const Icon(Icons.close,
                            size: 20, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}