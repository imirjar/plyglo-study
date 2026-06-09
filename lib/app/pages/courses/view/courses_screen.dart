import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/core/ui/app_header.dart';
import 'package:poliglotim/app/pages/courses/view/courses_body.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({super.key});

  final CoursesViewModel viewModel = Get.find<CoursesViewModel>();

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

        int crossAxisCount;
        if (screenWidth < 550) {
          crossAxisCount = 1;
        } else if (screenWidth < 760) {
          crossAxisCount = 2;
        } else if (screenWidth < 980) {
          crossAxisCount = 3;
        } else if (screenWidth < 1200) {
          crossAxisCount = 4;
        } else {
          crossAxisCount = 5;
        }

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
                    CoursesBody(
                      crossAxisCount: crossAxisCount,
                      screenWidth: screenWidth,
                      viewModel: widget.viewModel,
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
