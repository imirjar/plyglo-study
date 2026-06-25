import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/ui/core/ui/components/app_header.dart';
import 'package:poliglotim/app/ui/pages/course/view/course_view.dart';
import 'package:poliglotim/app/ui/pages/courses/view/courses_view.dart';
import 'package:poliglotim/app/ui/pages/exam/view/exam_screen.dart';
import 'package:poliglotim/app/ui/pages/user/view/user_screen.dart';

enum StudySection {
  courses,
  course,
  exam,
  user,
}

class StudyScreen extends StatelessWidget {
  const StudyScreen({
    super.key,
    required this.section,
  });

  final StudySection section;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          body: SafeArea(
            // child: Row()
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
      StudySection.courses => [
          CoursesScreen(screenWidth: screenWidth),
        ],
      StudySection.course => [
          SliverFillRemaining(
            child: CourseView(
              courseSlug: Get.parameters['courseSlug'] ?? '',
              courseId: _courseIdFromRoute(),
            ),
          ),
        ],
      StudySection.exam => [
          SliverFillRemaining( 
            child: ExamScreen(screenWidth: screenWidth),
          ),
        ],
      StudySection.user => [
          SliverFillRemaining(
            child: UserScreen(screenWidth: screenWidth),
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
