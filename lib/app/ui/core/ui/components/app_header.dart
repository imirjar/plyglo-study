import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/ui/core/ui/elements/buttons/circle_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late bool _isDarkMode = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.offAllNamed('/'),
            child: SizedBox(
              width: widget.screenWidth < 550 ? 128 : 156,
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/poliglotim_white.svg"
                    : "assets/images/poliglotim_black.svg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            children: [
              CircleButton(
                onPressed: _toggleTheme,
                icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              const SizedBox(width: 8),
              CircleButton(
                onPressed: () => Get.toNamed('/exam'),
                icon: Icons.sports_esports,
              ),
              const SizedBox(width: 8),
              CircleButton(
                onPressed: () => Get.toNamed('/user'),
                icon: Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
