import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:poliglotim/app/pages/core/themes/neumorphic.dart';
import 'package:poliglotim/app/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/pages/core/ui/elements/indicators/loading_indicator.dart';
import 'package:poliglotim/app/pages/core/ui/elements/placeholders/empty_placeholder.dart';

class CourseBody extends StatelessWidget {
  final CourseViewModel viewModel;
  const CourseBody({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorphic.panel(context),
      margin: const EdgeInsets.fromLTRB(16, 24, 24, 24),
      padding: const EdgeInsets.all(24),
      // ListenableBuilder теперь является единственным и главным механизмом
      // для обновления этого виджета.
      child: ListenableBuilder(
        listenable:
            viewModel, // Можно использовать viewModel вместо widget.viewModel
        builder: (context, _) {
          final lesson = viewModel.lesson;

          // Первым делом проверяем загрузку (можно добавить проверку lesson == null)
          if (viewModel.isLoading && lesson == null) {
            return const LoadingIndicator();
          }

          // Если не грузимся, но урока нет
          if (lesson == null) {
            return const EmptyPlaceholder(message: 'Выберите урок');
          }

          // Если урок есть, но текст пустой (возможно, грузится контент)
          if (lesson.text.isEmpty) {
            return const LoadingIndicator(message: 'Загрузка содержимого...');
          }

          // Если все хорошо, показываем контент
          return Markdown(data: lesson.text);
        },
      ),
    );
  }
}
