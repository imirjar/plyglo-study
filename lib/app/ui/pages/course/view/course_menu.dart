import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';

class CourseMenuItem {
  const CourseMenuItem({
    required this.id,
    required this.title,
    this.position,
  });

  final String id;
  final String title;
  final int? position;
}

class CourseMenu extends StatelessWidget {
  const CourseMenu({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onSelected,
  });

  final List<CourseMenuItem> items;
  final String? selectedItemId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorphic.panel(context),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return CourseMenuTile(
                    item: item,
                    isSelected: selectedItemId == item.id,
                    onTap: () => onSelected(item.id),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseMenuTile extends StatelessWidget {
  const CourseMenuTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CourseMenuItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${item.position ?? ''}',
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
                    item.title,
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
