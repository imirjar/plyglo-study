import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/course/view/course_body.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';

class CourseView extends StatefulWidget {
  const CourseView({
    super.key,
    required this.courseSlug,
    required this.courseId,
  });

  final String courseSlug;
  final String courseId;

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  late final CourseViewModel _viewModel = Get.find<CourseViewModel>();

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(CourseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId ||
        oldWidget.courseSlug != widget.courseSlug) {
      _loadCourse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CourseBody(viewModel: _viewModel);
  }

  void _loadCourse() {
    _viewModel.loadCourse(
      courseSlug: widget.courseSlug,
      courseId: widget.courseId,
    );
  }
}
