import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart';


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

