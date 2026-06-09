import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/pages/core/themes/neumorphic.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardPadding = switch (screenWidth) {
      < 600 => 16.0,
      < 980 => 18.0,
      < 1200 => 20.0,
      _ => 22.0,
    };
    final titleSize = switch (screenWidth) {
      < 600 => 24.0,
      < 980 => 26.0,
      < 1200 => 30.0,
      _ => 32.0,
    };
    final firstLetterSize = switch (screenWidth) {
      < 600 => 26.0,
      < 980 => 28.0,
      < 1200 => 32.0,
      _ => 34.0,
    };
    final descriptionSize = screenWidth < 1200 ? 14.0 : 15.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTap: () => Get.toNamed(
          '/${_slugFor(widget.course.name)}',
          arguments: {'courseId': widget.course.id},
        ),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed
              ? 0.985
              : _isHovered
                  ? 1.01
                  : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: Neumorphic.panel(
              context,
              isHovered: _isHovered,
              isPressed: _isPressed,
            ),
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'PonomarUnicode',
                      ),
                      children: _buildTitleWithRedLetters(
                        widget.course.name,
                        firstLetterSize: firstLetterSize,
                      ),
                    ),
                  ),
                ),
                if (widget.course.description.isNotEmpty && !isMobile)
                  Text(
                    widget.course.description.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'PonomarUnicode',
                      fontSize: descriptionSize,
                    ),
                    maxLines: screenWidth < 1200 ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _slugFor(String value) {
    final slug = value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    return Uri.encodeComponent(slug);
  }

  List<TextSpan> _buildTitleWithRedLetters(
    String text, {
    required double firstLetterSize,
  }) {
    final words = text.toUpperCase().split(' ');
    final spans = <TextSpan>[];

    for (var word in words) {
      if (word.isEmpty) continue;

      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: ' '));
      }

      spans.add(TextSpan(
        text: word.substring(0, 1),
        style: TextStyle(
          color: Colors.red,
          fontSize: firstLetterSize,
        ),
      ));

      if (word.length > 1) {
        spans.add(TextSpan(text: word.substring(1)));
      }
    }

    return spans;
  }
}
//       color: Theme.of(context).scaffoldBackgroundColor,
//       shape: shape,
//       borderRadius: isCircle ? null : borderRadius,
//       boxShadow: shadows,
//     ),
//     child: ClipRRect(
//       // borderRadius: isCircle ? null : borderRadius,
//       child: Padding(
//         padding: padding,
//         child: child,
//       ),
//     ),
//   );
// }
