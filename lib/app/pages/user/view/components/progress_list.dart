// progress_list.dart
import 'package:flutter/material.dart';
import 'package:poliglotim/app/data/models/progress.dart';

class ProgressList extends StatelessWidget {
  final List<CourseProgress> progress;

  const ProgressList({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Нет активных курсов'),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Прогресс по курсам',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...progress.map((courseProgress) => _ProgressItem(
                  progress: courseProgress,
                )),
          ],
        ),
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final CourseProgress progress;

  const _ProgressItem({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          progress.courseTitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.progressPercent / 100,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          '${progress.completedLessons} из ${progress.totalLessons} уроков '
          '(${progress.progressPercent.toStringAsFixed(1)}%)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
