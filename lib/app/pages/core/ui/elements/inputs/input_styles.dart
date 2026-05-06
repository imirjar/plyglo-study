import 'package:flutter/material.dart';

class InputStyles {
  static InputDecoration inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 123, 123, 123)),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
      );

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color.fromARGB(0, 66, 65, 65), width: 2),
  );
}