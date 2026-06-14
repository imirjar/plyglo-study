import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/pages/core/ui/elements/indicators/loading_indicator.dart';
import 'package:poliglotim/app/pages/core/ui/elements/placeholders/empty_placeholder.dart';
import 'package:poliglotim/app/pages/core/ui/learning_workspace.dart';
import 'package:poliglotim/app/pages/course/view/course_menu.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';

class CourseBody extends StatelessWidget {
  const CourseBody({
    super.key,
    required this.viewModel,
  });

  final CourseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return LearningWorkspace(
          menu: CourseMenu(
            items: viewModel.chapters
                .map(
                  (chapter) => CourseMenuItem(
                    id: chapter.id,
                    title: chapter.name,
                    position: chapter.position,
                  ),
                )
                .toList(),
            selectedItemId: viewModel.selectedChapter?.id,
            onSelected: (chapterId) {
              final chapter = viewModel.chapters.firstWhere(
                (chapter) => chapter.id == chapterId,
              );
              viewModel.selectChapter(chapter);
            },
          ),
          content: _LessonContentPanel(viewModel: viewModel),
        );
      },
    );
  }
}

class _LessonContentPanel extends StatelessWidget {
  const _LessonContentPanel({required this.viewModel});

  final CourseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LearningContentPanel(
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
              LearningNavigationBar<Lesson>(
                items: lessons,
                selectedItem: lesson,
                isLoading:
                    chapter != null && viewModel.isLoadingLessons(chapter.id),
                emptyMessage: 'Уроков пока нет',
                labelFor: (lesson, index) => '${lesson.position ?? index + 1}',
                tooltipFor: (lesson) => lesson.title,
                onSelected: viewModel.selectLesson,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (chapter == null) {
                      return const EmptyPlaceholder(message: 'Выберите главу');
                    }

                    if (lesson == null) {
                      return const EmptyPlaceholder(message: 'Выберите урок');
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
  }
}
