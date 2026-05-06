import 'package:flutter/material.dart';
import 'package:poliglotim/app/pages/course/view/course_body.dart';
import 'package:poliglotim/app/pages/course/view/course_menu.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';
import 'package:get/get.dart';

class CourseScreen extends StatefulWidget {
  late final CourseViewModel viewModel = CourseViewModel();
  late final String courseId = _courseIdFromRoute();
  final String courseSlug =
      Uri.decodeComponent(Get.parameters['courseSlug'] ?? '');

  CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();

  String _courseIdFromRoute() {
    final arguments = Get.arguments;
    if (arguments is Map && arguments['courseId'] is String) {
      return arguments['courseId'] as String;
    }

    return Uri.decodeComponent(Get.parameters['courseSlug'] ?? '');
  }
}

// course_screen.dart
class _CourseScreenState extends State<CourseScreen> {
  bool isMenuOpened = true;

  @override
  void initState() {
    super.initState();
    // ЗАГРУЗКА ДАННЫХ ИНИЦИИРУЕТСЯ ЗДЕСЬ!
    // Это гарантирует, что данные загрузятся всего один раз при открытии экрана,
    // независимо от того, что происходит с меню.
    widget.viewModel.loadChapters(widget.courseId);
  }

  @override
  void didUpdateWidget(CourseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если курс изменился (например, при навигации по deep link),
    // загружаем данные для нового курса.
    if (oldWidget.courseId != widget.courseId) {
      widget.viewModel.loadChapters(widget.courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            AnimatedMenuContainer(
              isExpanded: isMenuOpened,
              child: CourseMenu(
                courseId: widget.courseId,
                viewModel: widget.viewModel,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CourseBody(viewModel: widget.viewModel),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: const CircleBorder(),
                          side: BorderSide(color: Colors.grey.shade300),
                          elevation: 2,
                        ),
                        onPressed: () => toggleMenu(),
                        icon: Icon(isMenuOpened
                            ? Icons.chevron_left
                            : Icons.chevron_right),
                      ),
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

  void toggleMenu() {
    setState(() {
      isMenuOpened = !isMenuOpened;
    });
  }
}
