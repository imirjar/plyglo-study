import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/course/view/course_body.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/pages/core/ui/app_header.dart';

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

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: AppHeader(screenWidth: screenWidth),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    SliverFillRemaining(
                      child: CourseBody(viewModel: widget.viewModel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
