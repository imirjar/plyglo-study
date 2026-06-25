import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';

class NavigationTile extends StatefulWidget {
  const NavigationTile({
    super.key,
    required this.title,
    this.trailing,
    this.isSelected = false,
  });

  final String title;
  final Widget? trailing;
  final bool isSelected;

  @override
  State<NavigationTile> createState() => _NavigationTileState();
}

class _NavigationTileState extends State<NavigationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final active = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: active
            ? Neumorphic.panel(
                context,
                isHovered: _isHovered,
              )
            : null,
        child: Text(
          widget.title,
          softWrap: true,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: active
                ? colors.primary
                : colors.onSurface,
            fontWeight:
                active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}