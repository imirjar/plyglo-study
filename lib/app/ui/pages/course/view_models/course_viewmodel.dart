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
  final _log = Logger('CourseViewModel');

  CourseViewModel({CourseRepository? courseRepository})
      : _repository = courseRepository ?? Get.find<CourseRepository>();

  // State
  List<Chapter> _chapters = [];
  final Map<String, List<Lesson>> _lessonsByChapterId = {};
  bool _isLoading = false;
  String? _loadingLessonsChapterId;
  bool _isBodyOpened = false;
  Lesson? _lesson;
  Chapter? _selectedChapter;
  String? _error;

  // Getters
  List<Chapter> get chapters => _chapters;
  Lesson? get lesson => _lesson;
  bool get isLoading => _isLoading;
  String? get loadingLessonsChapterId => _loadingLessonsChapterId;
  bool get isBodyOpened => _isBodyOpened;
  Chapter? get selectedChapter => _selectedChapter;
  String? get error => _error;

  List<Lesson> get selectedChapterLessons {
    final chapter = _selectedChapter;
    if (chapter == null) return [];
    return lessonsForChapter(chapter.id);
  }

  List<Lesson> lessonsForChapter(String chapterId) {
    return _lessonsByChapterId[chapterId] ?? [];
  }

  bool isLoadingLessons(String chapterId) {
    return _loadingLessonsChapterId == chapterId;
  }

  Future<Result<void>> loadCourse({
    required String courseSlug,
    String? courseId,
  }) async {
    final resolvedCourseId = await _resolveCourseId(
      courseSlug: courseSlug,
      courseId: courseId,
    );

    switch (resolvedCourseId) {
      case Ok():
        return loadChapters(resolvedCourseId.value);
      case Error():
        _chapters = [];
        _lessonsByChapterId.clear();
        _lesson = null;
        _selectedChapter = null;
        _error = resolvedCourseId.error.toString();
        _isLoading = false;
        notifyListeners();
        return Result.error(resolvedCourseId.error);
    }
  }

  // Загрузка глав курса
  Future<Result<void>> loadChapters(String courseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // UI может показать индикатор загрузки

    final result = await _repository.getChapters(courseId);

    switch (result) {
      case Ok():
        _chapters = result.value;
        _lessonsByChapterId.clear();
        _lesson = null;
        _selectedChapter = _chapters.isEmpty ? null : _chapters.first;
        if (_selectedChapter != null) {
          await loadLessons(_selectedChapter!.id);
        }
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load chapters: ${result.error}");
    }

    _isLoading = false;
    notifyListeners(); // UI обновляется с новыми данными или ошибкой
    return result;
  }

  Future<void> selectChapter(Chapter chapter) async {
    _selectedChapter = chapter;
    _lesson = null;
    notifyListeners();
    await loadLessons(chapter.id);
  }

  // Повторная попытка загрузки
  Future<void> retryLoading(String courseId) async {
    _error = null;
    notifyListeners();
    await loadChapters(courseId);
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
        _lessonsByChapterId[chapterId] = result.value;
        if (_selectedChapter?.id == chapterId &&
            _lesson == null &&
            result.value.isNotEmpty) {
          await _loadLessonContent(result.value.first);
        }
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load lessons: ${result.error}");
    }

    _loadingLessonsChapterId = null;
    notifyListeners();
    return result;
  }

  // Выбор и загрузка урока
  Future<void> selectLesson(Lesson lesson) async {
    // Сохраняем выбранный урок сразу (например, чтобы подсветить его в меню)
    _lesson = lesson;
    _isLoading = true;
    _error = null;
    notifyListeners();

    await _loadLessonContent(lesson);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadLessonContent(Lesson lesson) async {
    _lesson = lesson;

    final result = await _repository.getLesson(lesson.id);

    switch (result) {
      case Ok():
        _lesson = result.value;
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load lesson content: ${result.error}");
    }
  }

  Future<void> toggleBody() async {
    _isBodyOpened = !_isBodyOpened;
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
        final course = _courseBySlug(coursesResult.value, courseSlug);
        if (course == null) {
          return Result.error(Exception('Course not found: $courseSlug'));
        }
        return Result.ok(course.id);
      case Error():
        return Result.error(coursesResult.error);
    }
  }

  Course? _courseBySlug(List<Course> courses, String slug) {
    final normalizedSlug = _decodeSlug(slug);
    for (final course in courses) {
      if (_slugFor(course.name) == normalizedSlug) return course;
    }
    return null;
  }

  String _slugFor(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
  }

  String _decodeSlug(String slug) {
    try {
      return Uri.decodeComponent(slug);
    } on FormatException {
      return slug;
    }
  }
}
