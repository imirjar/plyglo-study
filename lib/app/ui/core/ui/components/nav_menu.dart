import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/pages/course/view_models/course_viewmodel.dart';
import 'package:poliglotim/app/ui/core/ui/elements/buttons/nav_button.dart';


class NavMenu extends StatelessWidget {
  const NavMenu({
    super.key,
    required this.viewModel,
    required this.constraints,
  });

  final CourseViewModel viewModel;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final selectedId = viewModel.selectedChapter?.id;

    return ConstrainedBox(
      constraints: constraints,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        itemCount: viewModel.chapters.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final chapter = viewModel.chapters[index];

          return InkWell(
            onTap: () => viewModel.selectChapter(chapter),
            child: NavigationTile(
                    title: chapter.name,
                    isSelected: chapter.id == selectedId,
            ),
          );
        },
      ),
    );
  }
}
