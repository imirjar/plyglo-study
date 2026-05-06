import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle circleButtonStyle(bool isHovered) => ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 183, 37, 37),
        // overlayColor: Colors.red,
        padding: const EdgeInsets.all(35),
        shape: const CircleBorder(),
        elevation: isHovered ? 2 : 0,
      );
}