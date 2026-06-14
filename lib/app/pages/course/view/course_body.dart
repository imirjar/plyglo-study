import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/pages/core/themes/neumorphic.dart';
import 'package:poliglotim/app/pages/course/view/course_menu.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/pages/core/ui/elements/indicators/loading_indicator.dart';
import 'package:poliglotim/app/pages/core/ui/elements/placeholders/empty_placeholder.dart';

class CourseBody extends StatefulWidget {
  final CourseViewModel viewModel;
  const CourseBody({super.key, required this.viewModel});

  @override
  State<CourseBody> createState() => _CourseBodyState();
}

class _CourseBodyState extends State<CourseBody> {
  bool? _isMenuOpened;

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
        final toggleSlotWidth = isCompact ? 48.0 : 56.0;

        return Row(
          children: [
            AnimatedMenuContainer(
              isExpanded: _isMenuOpened!,
              width: menuWidth,
              child: CourseMenu(viewModel: widget.viewModel),
            ),
            SizedBox(
              width: toggleSlotWidth,
              child: Center(
                child: _MenuToggleButton(
                  isMenuOpened: _isMenuOpened!,
                  onPressed: _toggleMenu,
                ),
              ),
            ),
            Expanded(
              child: _LessonContentPanel(viewModel: widget.viewModel),
            ),
          ],
        );
      },
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpened = !(_isMenuOpened ?? true);
    });
  }
}

class _LessonContentPanel extends StatelessWidget {
  final CourseViewModel viewModel;
  const _LessonContentPanel({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 640 ? 18.0 : 24.0;

        return Container(
          decoration: Neumorphic.panel(context),
          padding: EdgeInsets.all(padding),
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              final chapter = viewModel.selectedChapter;
              final lessons = viewModel.selectedChapterLessons;
              final lesson = viewModel.lesson;

              if (viewModel.isLoading && chapter == null) {
                return const LoadingIndicator();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LessonNavigationBar(
                    lessons: lessons,
                    selectedLesson: lesson,
                    isLoading: chapter != null &&
                        viewModel.isLoadingLessons(chapter.id),
                    onLessonSelected: viewModel.selectLesson,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (chapter == null) {
                          return const EmptyPlaceholder(
                              message: 'Выберите главу');
                        }

                        if (lesson == null) {
                          return const EmptyPlaceholder(
                              message: 'Выберите урок');
                        }

                        if (viewModel.isLoading && lesson.text.isEmpty) {
                          return const LoadingIndicator(
                            message: 'Загрузка содержимого...',
                          );
                        }

                        if (lesson.text.isEmpty) {
                          return const EmptyPlaceholder(
                            message: 'У урока пока нет содержимого',
                          );
                        }

                        return Markdown(data: lesson.text);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _MenuToggleButton extends StatelessWidget {
  const _MenuToggleButton({
    required this.isMenuOpened,
    required this.onPressed,
  });

  final bool isMenuOpened;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(
        isMenuOpened ? Icons.chevron_left : Icons.chevron_right,
      ),
    );
  }
}

class LessonNavigationBar extends StatelessWidget {
  final List<Lesson> lessons;
  final Lesson? selectedLesson;
  final bool isLoading;
  final ValueChanged<Lesson> onLessonSelected;

  const LessonNavigationBar({
    super.key,
    required this.lessons,
    required this.selectedLesson,
    required this.isLoading,
    required this.onLessonSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 44,
        child: Align(
          alignment: Alignment.centerLeft,
          child: LoadingIndicator(size: 20),
        ),
      );
    }

    if (lessons.isEmpty) {
      return SizedBox(
        height: 44,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Уроков пока нет',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 44,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: lessons.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final isSelected = selectedLesson?.id == lesson.id;

            return LessonNavigationButton(
              lesson: lesson,
              label: '${lesson.position ?? index + 1}',
              isSelected: isSelected,
              onTap: () => onLessonSelected(lesson),
            );
          },
        ),
      ),
    );
  }
}

class LessonNavigationButton extends StatelessWidget {
  final Lesson lesson;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LessonNavigationButton({
    super.key,
    required this.lesson,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: lesson.title,
      child: DecoratedBox(
        decoration: isSelected
            ? BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              )
            : Neumorphic.panel(context),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
