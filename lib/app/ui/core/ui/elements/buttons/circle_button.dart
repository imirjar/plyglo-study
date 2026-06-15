import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';

class CircleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;

  const CircleButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48,
  });

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: widget.size,
            height: widget.size,
            decoration: Neumorphic.panel(
              context,
              isHovered: _isHovered,
              isPressed: _isPressed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: Theme.of(context).colorScheme.primary,
                size: widget.size * 0.45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
