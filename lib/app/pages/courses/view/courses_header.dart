import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/core/ui/elements/buttons/circle_button.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoursesHeader extends StatefulWidget {
  const CoursesHeader(
      {super.key, required this.screenWidth, required this.viewModel});

  final CoursesViewModel viewModel;
  final double screenWidth;

  @override
  State<CoursesHeader> createState() => _CoursesHeaderState();
}

class _CoursesHeaderState extends State<CoursesHeader> {
  late bool _isDarkMode = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: widget.screenWidth < 550 ? 128 : 156,
            child: SvgPicture.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/poliglotim_white.svg"
                  : "assets/images/poliglotim_black.svg",
              fit: BoxFit.contain,
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
