import 'package:flutter/material.dart';
import 'package:poliglotim/app/pages/courses/view/components/course_card.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';

class CoursesBody extends StatelessWidget {
  final CoursesViewModel viewModel;
  final int crossAxisCount;

  const CoursesBody(
      {super.key, required this.crossAxisCount, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.18,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: viewModel.courses.length,
          itemBuilder: (context, index) => CourseCard(
            course: viewModel.courses[index],
          ),
        );
      },
    );
  }
}
