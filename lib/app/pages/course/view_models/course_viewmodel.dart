import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/chapter.dart';
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
  String? _error;

  // Getters
  List<Chapter> get chapters => _chapters;
  Lesson? get lesson => _lesson;
  bool get isLoading => _isLoading;
  String? get loadingLessonsChapterId => _loadingLessonsChapterId;
  bool get isBodyOpened => _isBodyOpened;
  String? get error => _error;

  List<Lesson> lessonsForChapter(String chapterId) {
    return _lessonsByChapterId[chapterId] ?? [];
  }

  bool isLoadingLessons(String chapterId) {
    return _loadingLessonsChapterId == chapterId;
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
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load chapters: ${result.error}");
    }

    _isLoading = false;
    notifyListeners(); // UI обновляется с новыми данными или ошибкой
    return result;
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

    final result = await _repository.getLesson(lesson.id);

    switch (result) {
      case Ok():
        _lesson = result.value; // Заменяем на урок с полным содержимым
      case Error():
        _error = result.error.toString();
        _log.warning("Failed to load lesson content: ${result.error}");
      // Урок уже выбран (_lesson = lesson), оставляем его
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleBody() async {
    _isBodyOpened = !_isBodyOpened;
    notifyListeners();
  }
}
