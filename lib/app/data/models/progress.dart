// course_progress.dart
class CourseProgress {
  final String courseId;
  final String courseTitle;
  final int completedLessons;
  final int totalLessons;
  final double progressPercent;

  CourseProgress({
    required this.courseId,
    required this.courseTitle,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercent,
  });
}