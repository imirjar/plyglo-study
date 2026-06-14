import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/courses/view/courses_body.dart';
import 'package:poliglotim/app/pages/courses/view_models/courses_viewmodel.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  late final CoursesViewModel _viewModel = Get.find<CoursesViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return CoursesBody(
      crossAxisCount: _crossAxisCount(widget.screenWidth),
      screenWidth: widget.screenWidth,
      viewModel: _viewModel,
    );
  }

  int _crossAxisCount(double screenWidth) {
    if (screenWidth < 550) return 1;
    if (screenWidth < 760) return 2;
    if (screenWidth < 980) return 3;
    if (screenWidth < 1200) return 4;
    return 5;
  }
}
