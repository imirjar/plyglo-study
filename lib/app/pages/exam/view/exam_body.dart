import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:poliglotim/app/data/models/exam.dart';
import 'package:poliglotim/app/pages/exam/game/exam_flame_game.dart';
import 'package:poliglotim/app/pages/exam/view_models/exam_viewmodel.dart';

class ExamBody extends StatelessWidget {
  const ExamBody({
    super.key,
    required this.screenWidth,
    required this.viewModel,
  });

  final double screenWidth;
  final ExamViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = viewModel.error;
        if (error != null) {
          return Center(child: Text(error));
        }

        final exam = viewModel.exam;
        final task = viewModel.selectedTask;
        if (exam == null || task == null) {
          return const Center(child: Text('Exam is empty'));
        }

        final isWide = screenWidth >= 900;
        final content = [
          _TaskRail(
            exam: exam,
            selectedIndex: viewModel.selectedIndex,
            completedCount: viewModel.completedCount,
            onSelected: viewModel.selectTask,
          ),
          Expanded(
            child: _GamePanel(
              task: task,
              onCompleted: viewModel.completeSelectedTask,
            ),
          ),
        ];

        return Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth < 600 ? 16 : 10,
            0,
            screenWidth < 600 ? 16 : 10,
            24,
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(width: 300, child: content.first),
                    const SizedBox(width: 20),
                    content.last,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 132, child: content.first),
                    const SizedBox(height: 16),
                    SizedBox(height: 560, child: content.last),
                  ],
                ),
        );
      },
    );
  }
}

class _TaskRail extends StatelessWidget {
  const _TaskRail({
    required this.exam,
    required this.selectedIndex,
    required this.completedCount,
    required this.onSelected,
  });

  final Exam exam;
  final int selectedIndex;
  final int completedCount;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: .28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$completedCount / ${exam.tasks.length} completed',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: exam.tasks.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = exam.tasks[index];
                  final selected = index == selectedIndex;
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onSelected(index),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.colorScheme.primary.withValues(alpha: .12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GamePanel extends StatelessWidget {
  const _GamePanel({
    required this.task,
    required this.onCompleted,
  });

  final ExamTask task;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GameWidget(
        key: ValueKey(task.id),
        game: ExamFlameGame(
          task: task,
          onCompleted: onCompleted,
          isDark: isDark,
        ),
      ),
    );
  }
}
