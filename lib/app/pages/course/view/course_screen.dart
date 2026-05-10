import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/course/view/course_body.dart';
import 'package:poliglotim/app/pages/course/view/course_menu.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';

class CourseScreen extends StatefulWidget {
  late final CourseViewModel viewModel = Get.find<CourseViewModel>();
  late final String courseId = _courseIdFromRoute();
  late final String courseSlug = Get.parameters['courseSlug'] ?? '';

  CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();

  String _courseIdFromRoute() {
    final arguments = Get.arguments;
    if (arguments is Map && arguments['courseId'] is String) {
      return arguments['courseId'] as String;
    }

    return '';
  }
}

// course_screen.dart
class _CourseScreenState extends State<CourseScreen> {
  bool isMenuOpened = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadCourse(
      courseSlug: widget.courseSlug,
      courseId: widget.courseId,
    );
  }

  @override
  void didUpdateWidget(CourseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если курс изменился (например, при навигации по deep link),
    // загружаем данные для нового курса.
    if (oldWidget.courseId != widget.courseId ||
        oldWidget.courseSlug != widget.courseSlug) {
      widget.viewModel.loadCourse(
        courseSlug: widget.courseSlug,
        courseId: widget.courseId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
        final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;
        final menuWidth = screenWidth < 900 ? 268.0 : 296.0;
        final toggleSlotWidth = screenWidth < 700 ? 52.0 : 56.0;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Row(
                    children: [
                      AnimatedMenuContainer(
                        isExpanded: isMenuOpened,
                        width: menuWidth,
                        child: CourseMenu(viewModel: widget.viewModel),
                      ),
                      SizedBox(
                        width: toggleSlotWidth,
                        child: Center(
                          child: _MenuToggleButton(
                            isMenuOpened: isMenuOpened,
                            onPressed: toggleMenu,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CourseBody(viewModel: widget.viewModel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void toggleMenu() {
    setState(() {
      isMenuOpened = !isMenuOpened;
    });
  }
}

class _MenuToggleButton extends StatelessWidget {
  const _MenuToggleButton({
    required this.isMenuOpened,
    required this.onPressed,
  });

  final bool isMenuOpened;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(
        isMenuOpened ? Icons.chevron_left : Icons.chevron_right,
      ),
    );
  }
}
