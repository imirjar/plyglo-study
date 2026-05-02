import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poliglotim/ui/course/view_models/course_viewmodel.dart';

import 'package:poliglotim/domain/models/lesson.dart';
import 'package:poliglotim/domain/models/chapter.dart';

import 'package:poliglotim/ui/core/ui/elements/indicators/loading_indicator.dart';

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
    return Column(
      children: [
        GestureDetector(
          onTap: () => GoRouter.of(context).go("/"),
          child: SvgPicture.asset(
            "assets/images/poliglotim_white.svg",
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Expanded(
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16, left: 18),
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
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
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
                padding: const EdgeInsets.only(left: 24),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
      width: isExpanded ? 280 : 0,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: 280,
          child: child,
        ),
      ),
    );
  }
}
