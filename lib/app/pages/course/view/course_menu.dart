import 'package:flutter/material.dart';
import 'package:poliglotim/app/pages/core/themes/neumorphic.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';

import 'package:poliglotim/app/data/models/chapter.dart';

class CourseMenu extends StatelessWidget {
  final CourseViewModel viewModel;

  const CourseMenu({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorphic.panel(context),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
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
    final isSelected = viewModel.selectedChapter?.id == chapter.id;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => viewModel.selectChapter(chapter),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${chapter.position ?? ''}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    chapter.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.25,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedMenuContainer extends StatelessWidget {
  final bool isExpanded;
  final double width;
  final Widget child;

  const AnimatedMenuContainer({
    super.key,
    required this.isExpanded,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? width : 0,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: width,
          child: child,
        ),
      ),
    );
  }
}
