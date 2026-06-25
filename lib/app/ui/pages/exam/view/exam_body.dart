import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:poliglotim/app/data/models/exam.dart';
import 'package:poliglotim/app/ui/core/ui/screens/learning_workspace.dart';
// import 'package:poliglotim/app/ui/core/ui/components/nav_menu.dart';
import 'package:poliglotim/app/ui/core/ui/components/nav_bar.dart';
import 'package:poliglotim/app/ui/pages/exam/game/exam_flame_game.dart';
import 'package:poliglotim/app/ui/pages/exam/view_models/exam_viewmodel.dart';

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
        if (exam == null) {
          return const Center(child: Text('Exam is empty'));
        }
  return Row();
        // return LearningWorkspace(
        //   menu: NavMenu(
        //     items: exam.gameTopics
        //         .map(
        //           (topic) => NavMenuItem(
        //             id: topic.id,
        //             title: topic.name,
        //             position: topic.position,
        //           ),
        //         )
        //         .toList(),
        //     selectedItemId: viewModel.selectedTopic?.id,
        //     onSelected: viewModel.selectTopic,
        //   ),
        //   content: _ExamContentPanel(viewModel: viewModel),
        // );
      },
    );
  }
}

class _ExamContentPanel extends StatelessWidget {
  const _ExamContentPanel({required this.viewModel});

  final ExamViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final task = viewModel.selectedTask;
    final tasks = viewModel.selectedTopicTasks;

    return LearningContentPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LearningNavigationBar<ExamTask>(
            items: tasks,
            selectedItem: task,
            emptyMessage: 'Игр пока нет',
            labelFor: (task, index) => '${index + 1}',
            tooltipFor: (task) => task.title,
            onSelected: viewModel.selectTask,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: task == null
                ? const Center(child: Text('Выберите игру'))
                : _GamePanel(
                    task: task,
                    onCompleted: viewModel.completeSelectedTask,
                  ),
          ),
        ],
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
