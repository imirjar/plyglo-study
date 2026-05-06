import 'package:flutter/material.dart';

abstract final class Neumorphic {
  static BoxDecoration panel(
    BuildContext context, {
    bool isHovered = false,
    bool isPressed = false,
    BoxShape shape = BoxShape.rectangle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = shape == BoxShape.circle
        ? null
        : const BorderRadius.all(Radius.circular(8));

    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      shape: shape,
      borderRadius: radius,
      boxShadow: isDark
          ? _darkShadows(isHovered: isHovered, isPressed: isPressed)
          : _lightShadows(isHovered: isHovered, isPressed: isPressed),
    );
  }

  static List<BoxShadow> _lightShadows({
    required bool isHovered,
    required bool isPressed,
  }) {
    if (isPressed) {
      return const [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(-4, -4),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(4, 4),
          blurRadius: 10,
        ),
      ];
    }

    if (isHovered) {
      return const [
        BoxShadow(
          color: Colors.white,
          offset: Offset(-7, -7),
          blurRadius: 16,
        ),
        BoxShadow(
          color: Color(0x40000000),
          offset: Offset(8, 8),
          blurRadius: 22,
        ),
      ];
    }

    return const [
      BoxShadow(
        color: Colors.white,
        offset: Offset(-5, -5),
        blurRadius: 12,
      ),
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(6, 6),
        blurRadius: 16,
      ),
    ];
  }

  static List<BoxShadow> _darkShadows({
    required bool isHovered,
    required bool isPressed,
  }) {
    if (isPressed) {
      return const [
        BoxShadow(
          color: Colors.white10,
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.black54,
          offset: Offset(-4, -4),
          blurRadius: 10,
        ),
      ];
    }

    if (isHovered) {
      return const [
        BoxShadow(
          color: Colors.black87,
          offset: Offset(8, 8),
          blurRadius: 20,
        ),
        BoxShadow(
          color: Colors.white12,
          offset: Offset(-6, -6),
          blurRadius: 14,
        ),
      ];
    }

    return const [
      BoxShadow(
        color: Colors.black54,
        offset: Offset(6, 6),
        blurRadius: 14,
      ),
      BoxShadow(
        color: Colors.white10,
        offset: Offset(-4, -4),
        blurRadius: 10,
      ),
    ];
  }
}
