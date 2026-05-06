import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';

import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/data/models/chapter.dart';

import 'package:poliglotim/app/pages/core/ui/elements/indicators/loading_indicator.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CourseMenu extends StatelessWidget {
  final String courseId;
  final CourseViewModel viewModel;

  const CourseMenu({
    super.key,
    required this.courseId,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.offAllNamed('/'),
            child: SizedBox(
              width: 144,
              height: 56,
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/poliglotim_white.svg"
                    : "assets/images/poliglotim_black.svg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: viewModel.chapters.length,
                    itemBuilder: (context, index) => ChapterTile(
                      chapter: viewModel.chapters[index],
                      viewModel: viewModel,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final CourseViewModel viewModel;

  const ChapterTile({
    super.key,
    required this.chapter,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = viewModel.lessonsForChapter(chapter.id);
    final isLoading = viewModel.isLoadingLessons(chapter.id);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            viewModel.loadLessons(chapter.id);
          }
        },
        trailing: const SizedBox.shrink(),
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          chapter.name,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        children: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LoadingIndicator(size: 20),
            )
          else if (lessons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Уроков пока нет'),
              ),
            )
          else
            for (Lesson lesson in lessons)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(lesson.title),
                  onTap: () => viewModel.selectLesson(lesson),
                ),
              ),
        ],
      ),
    );
  }
}

class AnimatedMenuContainer extends StatelessWidget {
  final bool isExpanded;
  final Widget child;

  const AnimatedMenuContainer({
    super.key,
    required this.isExpanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 296 : 0,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: 296,
          child: child,
        ),
      ),
    );
  }
}
