import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:poliglotim/app/data/models/exam.dart';
import 'package:poliglotim/app/ui/pages/exam/view_models/exam_viewmodel.dart';
import 'package:poliglotim/app/ui/pages/exam/game/exam_flame_game.dart';
import 'package:poliglotim/app/ui/core/ui/elements/buttons/toggle_button.dart';
import 'package:poliglotim/app/ui/core/ui/screens/learning_workspace.dart';
import 'package:poliglotim/app/ui/core/ui/components/nav_bar.dart';


class ExamView extends StatefulWidget {
  const ExamView({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  late final ExamViewModel _viewModel = Get.find<ExamViewModel>();
  bool? _isMenuOpened;

  @override
  void initState() {
    super.initState();
    _viewModel.loadExam();
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
        // return LearningWorkspace(
        children: [
          ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                widthFactor: _isMenuOpened! ? 1 : 0,
                child: SizedBox(
                  width: menuWidth,
                  // child: NavMenu(
                  //   viewModel: _viewModel,
                  //   constraints: constraints,
                  // )

                ),
              ),
          
          ),
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
              child: _ExamContentPanel(
                viewModel: _viewModel,
              ),
            ),
          // content: _ExamContentPanel(viewModel: viewModel),
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
