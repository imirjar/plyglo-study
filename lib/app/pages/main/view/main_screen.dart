import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/core/ui/app_header.dart';
import 'package:poliglotim/app/pages/course/view/course_view.dart';
import 'package:poliglotim/app/pages/courses/view/courses_view.dart';
import 'package:poliglotim/app/pages/exam/view/exam_view.dart';
import 'package:poliglotim/app/pages/user/view/user_view.dart';

enum MainSection {
  courses,
  course,
  exam,
  user,
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.section,
  });

  final MainSection section;

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
                    ..._bodySlivers(screenWidth),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _bodySlivers(double screenWidth) {
    return switch (section) {
      MainSection.courses => [
          CoursesView(screenWidth: screenWidth),
        ],
      MainSection.course => [
          SliverFillRemaining(
            child: CourseView(
              courseSlug: Get.parameters['courseSlug'] ?? '',
              courseId: _courseIdFromRoute(),
            ),
          ),
        ],
      MainSection.exam => [
          SliverFillRemaining(
            child: ExamView(screenWidth: screenWidth),
          ),
        ],
      MainSection.user => [
          SliverFillRemaining(
            child: UserView(screenWidth: screenWidth),
          ),
        ],
    };
  }

  String _courseIdFromRoute() {
    final arguments = Get.arguments;
    if (arguments is Map && arguments['courseId'] is String) {
      return arguments['courseId'] as String;
    }

    return '';
  }
}
