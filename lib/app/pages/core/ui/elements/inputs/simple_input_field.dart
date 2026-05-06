import 'package:flutter/material.dart';
import 'input_styles.dart';

class SimpleInputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const SimpleInputField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputStyles.inputDecoration(label),
      validator: validator,
    );
  }
}