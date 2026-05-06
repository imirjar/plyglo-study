import 'package:flutter/material.dart';
import 'package:poliglotim/app/pages/courses/view/courses_body.dart';
import 'package:poliglotim/app/pages/courses/view/courses_header.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({super.key});

  final CoursesViewModel viewModel = CoursesViewModel();

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = screenWidth < 600 ? 16.0 : 32.0;
        final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

        int crossAxisCount;
        if (screenWidth < 550) {
          crossAxisCount = 1;
        } else if (screenWidth < 800) {
          crossAxisCount = 2;
        } else if (screenWidth < 1150) {
          crossAxisCount = 3;
        } else if (screenWidth < 1300) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 5;
        }

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
                  child: Column(
                    children: [
                      CoursesHeader(
                        viewModel: widget.viewModel,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: CoursesBody(
                          crossAxisCount: crossAxisCount,
                          viewModel: widget.viewModel,
                        ),
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
}
