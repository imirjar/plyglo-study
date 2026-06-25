import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:poliglotim/app/data/models/lesson.dart';

import 'package:poliglotim/app/ui/pages/course/view_models/course_viewmodel.dart';

import 'package:poliglotim/app/ui/core/ui/elements/indicators/loading_indicator.dart';
import 'package:poliglotim/app/ui/core/ui/elements/placeholders/empty_placeholder.dart';

import 'package:poliglotim/app/ui/core/ui/screens/learning_workspace.dart';

import 'package:poliglotim/app/ui/core/ui/components/nav_bar.dart';

class LessonContentPanel extends StatelessWidget {
  const LessonContentPanel({super.key, required this.viewModel});

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