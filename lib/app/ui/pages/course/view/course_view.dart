import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:poliglotim/app/ui/core/ui/screens/learning_workspace.dart';

import 'package:poliglotim/app/ui/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/ui/core/ui/components/content_panel.dart';
import 'package:poliglotim/app/ui/core/ui/components/nav_menu.dart';
import 'package:poliglotim/app/ui/core/ui/elements/buttons/toggle_button.dart';

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
  bool? _isMenuOpened;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(covariant CourseView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.courseId != widget.courseId ||
        oldWidget.courseSlug != widget.courseSlug) {
      _loadCourse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 700;

        _isMenuOpened ??= !isCompact;

        final menuWidth = isCompact
            ? (constraints.maxWidth * 0.72).clamp(220.0, 268.0)
            : constraints.maxWidth < 900
                ? 268.0
                : 296.0;

        return Row(
          children: [ 
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                widthFactor: _isMenuOpened! ? 1 : 0,
                child: SizedBox(
                  width: menuWidth,
                  child: NavMenu(
                    viewModel: _viewModel,
                    constraints: constraints,
                  ),
                ),
              ),
            ),
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 300),
            //   width: _isMenuOpened! ? menuWidth : 0,
            //   child: NavMenu(
            //     viewModel: _viewModel,
            //     // width: menuWidth,
            //     constraints: constraints,
            //   ),
            // ),
            SizedBox(
              width: isCompact ? 48 : 56,
              child: Center(
                child: MenuToggleButton(
                  isMenuOpened: _isMenuOpened!,
                  onPressed: _toggleMenu,
                ),
              ),
            ),
            Expanded(
              child: LessonContentPanel(
                viewModel: _viewModel,
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpened = !_isMenuOpened!;
    });
  }

  void _loadCourse() {
    _viewModel.loadCourse(
      courseSlug: widget.courseSlug,
      courseId: widget.courseId,
    );
  }
}