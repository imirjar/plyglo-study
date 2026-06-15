import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';

class LearningWorkspace extends StatefulWidget {
  const LearningWorkspace({
    super.key,
    required this.menu,
    required this.content,
  });

  final Widget menu;
  final Widget content;

  @override
  State<LearningWorkspace> createState() => _LearningWorkspaceState();
}

class _LearningWorkspaceState extends State<LearningWorkspace> {
  bool? _isMenuOpened;

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
        final toggleSlotWidth = isCompact ? 48.0 : 56.0;

        return Row(
          children: [
            AnimatedMenuContainer(
              isExpanded: _isMenuOpened!,
              width: menuWidth,
              child: widget.menu,
            ),
            SizedBox(
              width: toggleSlotWidth,
              child: Center(
                child: _MenuToggleButton(
                  isMenuOpened: _isMenuOpened!,
                  onPressed: _toggleMenu,
                ),
              ),
            ),
            Expanded(child: widget.content),
          ],
        );
      },
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpened = !(_isMenuOpened ?? true);
    });
  }
}

class LearningContentPanel extends StatelessWidget {
  const LearningContentPanel({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 640 ? 18.0 : 24.0;

        return Container(
          decoration: Neumorphic.panel(context),
          padding: EdgeInsets.all(padding),
          child: child,
        );
      },
    );
  }
}

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

class AnimatedMenuContainer extends StatelessWidget {
  const AnimatedMenuContainer({
    super.key,
    required this.isExpanded,
    required this.width,
    required this.child,
  });

  final bool isExpanded;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? width : 0,
      curve: Curves.easeInOut,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          maxWidth: width,
          child: child,
        ),
      ),
    );
  }
}

class _MenuToggleButton extends StatelessWidget {
  const _MenuToggleButton({
    required this.isMenuOpened,
    required this.onPressed,
  });

  final bool isMenuOpened;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(
        isMenuOpened ? Icons.chevron_left : Icons.chevron_right,
      ),
    );
  }
}
