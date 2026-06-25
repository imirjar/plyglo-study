import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/chapter.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/data/models/lesson.dart';
import 'package:poliglotim/app/data/repositories/course_repository.dart';

class CourseViewModel extends ChangeNotifier {
  final CourseRepository _repository;
  final Logger _log = Logger('CourseViewModel');

  CourseViewModel({
    CourseRepository? courseRepository,
  }) : _repository = courseRepository ?? Get.find<CourseRepository>();

  List<Chapter> _chapters = [];
  final Map<String, List<Lesson>> _lessonsByChapterId = {};

  Lesson? _lesson;
  Chapter? _selectedChapter;

  bool _isLoading = false;
  String? _loadingLessonsChapterId;
  String? _error;

  // Getters

  List<Chapter> get chapters => _chapters;

  Lesson? get lesson => _lesson;

  Chapter? get selectedChapter => _selectedChapter;

  bool get isLoading => _isLoading;

  String? get loadingLessonsChapterId => _loadingLessonsChapterId;

  String? get error => _error;

  List<Lesson> get selectedChapterLessons {
    final chapter = _selectedChapter;

    if (chapter == null) {
      return const [];
    }

    return lessonsForChapter(chapter.id);
  }

  List<Lesson> lessonsForChapter(String chapterId) {
    return _lessonsByChapterId[chapterId] ?? const [];
  }

  bool isLoadingLessons(String chapterId) {
    return _loadingLessonsChapterId == chapterId;
  }

  Future<void> loadCourse({
    required String courseSlug,
    String? courseId,
  }) async {
    final result = await _resolveCourseId(
      courseSlug: courseSlug,
      courseId: courseId,
    );

    switch (result) {
      case Ok():
        await loadChapters(result.value);

      case Error():
        _clearData();
        _setError(result.error);
    }
  }

  Future<Result<void>> loadChapters(String courseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getChapters(courseId);

    switch (result) {
      case Ok():
        _chapters = result.value;
        _selectedChapter = _chapters.isEmpty ? null : _chapters.first;

        _lessonsByChapterId.clear();
        _lesson = null;

        if (_selectedChapter != null) {
          await loadLessons(_selectedChapter!.id);
        }

      case Error():
        _setError(result.error);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<void> selectChapter(Chapter chapter) async {
    _selectedChapter = chapter;
    _lesson = null;

    notifyListeners();

    await loadLessons(chapter.id);
  }

  Future<Result<void>> loadLessons(String chapterId) async {
    if (_lessonsByChapterId.containsKey(chapterId)) {
      return const Result.ok(null);
    }

    _loadingLessonsChapterId = chapterId;
    _error = null;

    notifyListeners();

    final result = await _repository.getLessons(chapterId);

    switch (result) {
      case Ok():
        final lessons = result.value;

        _lessonsByChapterId[chapterId] = lessons;

        await _selectFirstLesson(chapterId, lessons);

      case Error():
        _setError(result.error);
    }

    _loadingLessonsChapterId = null;

    notifyListeners();

    return result;
  }

  Future<void> selectLesson(Lesson lesson) async {
    _isLoading = true;
    _lesson = lesson;
    _error = null;

    notifyListeners();

    await loadLesson(lesson.id);

    _isLoading = false;

    notifyListeners();
  }

  Future<Result<void>> loadLesson(String lessonId) async {
    final result = await _repository.getLesson(lessonId);

    switch (result) {
      case Ok():
        _lesson = result.value;

      case Error():
        _setError(result.error);
    }

    return result;
  }

  Future<void> retryLoading(String courseId) async {
    _error = null;

    notifyListeners();

    await loadChapters(courseId);
  }

  Future<void> _selectFirstLesson(
    String chapterId,
    List<Lesson> lessons,
  ) async {
    if (_selectedChapter?.id != chapterId) return;
    if (_lesson != null) return;
    if (lessons.isEmpty) return;

    await loadLesson(lessons.first.id);
  }

  void _clearData() {
    _chapters = [];
    _lessonsByChapterId.clear();
    _lesson = null;
    _selectedChapter = null;
    _isLoading = false;
  }

  void _setError(Object error) {
    _error = error.toString();
    _log.warning(error);
    notifyListeners();
  }

  Future<Result<String>> _resolveCourseId({
    required String courseSlug,
    String? courseId,
  }) async {
    if (courseId != null && courseId.isNotEmpty) {
      final courseResult = await _repository.getCourse(courseId);

      return switch (courseResult) {
        Ok() => Result.ok(courseResult.value.id),
        Error() => Result.error(courseResult.error),
      };
    }

    final coursesResult = await _repository.getCourses();

    switch (coursesResult) {
      case Ok():
        final course = _courseBySlug(
          coursesResult.value,
          courseSlug,
        );

        if (course == null) {
          return Result.error(
            Exception('Course not found: $courseSlug'),
          );
        }

        return Result.ok(course.id);

      case Error():
        return Result.error(coursesResult.error);
    }
  }

  Course? _courseBySlug(
    List<Course> courses,
    String slug,
  ) {
    final normalizedSlug = _decodeSlug(slug);

    for (final course in courses) {
      if (_slugFor(course.name) == normalizedSlug) {
        return course;
      }
    }

    return null;
  }

  String _slugFor(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  String _decodeSlug(String slug) {
    try {
      return Uri.decodeComponent(slug);
    } on FormatException {
      return slug;
    }
  }
}