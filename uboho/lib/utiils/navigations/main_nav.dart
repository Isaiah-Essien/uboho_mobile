import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uboho/features/screens/chat/chat_screen.dart';
import 'package:uboho/features/screens/home/home_screen.dart';
import 'package:uboho/features/screens/settings/settings_screen.dart';
import 'package:uboho/utiils/constants/colors.dart';
import 'package:uboho/utiils/constants/icons.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: UColors.backgroundColor,
            borderRadius: BorderRadius.circular(53.33),
            border: Border.all(
              color: UColors.inputInactiveColor,
              width: 1.07,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                iconPath: UIcons.homeIcon,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                iconPath: UIcons.chatIcon,
                label: 'Chat',
                index: 1,
              ),
              _buildNavItem(
                iconPath: UIcons.settingsIcon,
                label: 'Settings',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 64,
          decoration: BoxDecoration(
            color: isSelected ? UColors.boxHighlightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(53.33),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    height: 25.6,
                    width: 25.6,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  if (isSelected && label.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(label, style: const TextStyle(color: Colors.white)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
