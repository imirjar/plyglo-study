import 'package:flutter/material.dart';

class MenuToggleButton extends StatelessWidget {
  const MenuToggleButton({
    super.key,
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
