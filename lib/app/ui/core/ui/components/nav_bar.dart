import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';

class LearningNavigationBar<T> extends StatelessWidget {
  const LearningNavigationBar({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.labelFor,
    required this.tooltipFor,
    required this.onSelected,
    this.isLoading = false,
    this.emptyMessage = 'Элементов пока нет',
  });

  final List<T> items;
  final T? selectedItem;
  final String Function(T item, int index) labelFor;
  final String Function(T item) tooltipFor;
  final ValueChanged<T> onSelected;
  final bool isLoading;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 44,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return SizedBox(
        height: 44,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            emptyMessage,
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
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            return LearningNavigationButton(
              label: labelFor(item, index),
              tooltip: tooltipFor(item),
              isSelected: identical(item, selectedItem),
              onTap: () => onSelected(item),
            );
          },
        ),
      ),
    );
  }
}

class LearningNavigationButton extends StatelessWidget {
  const LearningNavigationButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
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
