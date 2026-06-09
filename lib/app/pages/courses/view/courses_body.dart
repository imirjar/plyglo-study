import 'package:flutter/material.dart';
import 'package:poliglotim/app/pages/courses/view/components/course_card.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';

class CoursesBody extends StatelessWidget {
  final CoursesViewModel viewModel;
  final int crossAxisCount;
  final double screenWidth;

  const CoursesBody(
      {super.key,
      required this.crossAxisCount,
      required this.screenWidth,
      required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final isMobile = screenWidth < 600;
        final childAspectRatio = switch (screenWidth) {
          < 600 => 2.05,
          < 760 => 1.72,
          < 980 => 1.58,
          < 1200 => 1.42,
          _ => 1.24,
        };

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 16 : 10,
            isMobile ? 16 : 0,
            isMobile ? 16 : 0,
            24,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: isMobile ? 16 : 20,
              crossAxisSpacing: isMobile ? 16 : 20,
            ),
            itemCount: viewModel.courses.length,
            itemBuilder: (context, index) => CourseCard(
              course: viewModel.courses[index],
            ),
          ),
        );
      },
    );
  }
}
