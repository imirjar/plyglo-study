import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:poliglotim/domain/models/chapter.dart';
import 'package:poliglotim/domain/models/lesson.dart';
import 'package:poliglotim/data/repositories/courses/course_repository.dart';
import 'package:poliglotim/utils/result.dart';

class CourseViewModel extends ChangeNotifier {
  final CourseRepository _repository;
  final _log = Logger('CourseViewModel');

  CourseViewModel({  
    required CourseRepository courseRepository,
  }) : _repository = courseRepository;

  // State
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  bool _isBodyOpened = false;
  Lesson? _lesson;
  String? _error;

  // Getters
  List<Chapter> get chapters => _chapters;
  Lesson? get lesson => _lesson;
  bool get isLoading => _isLoading;
  bool get isBodyOpened => _isBodyOpened;
  String? get error => _error;

  // Загрузка глав курса
  Future<Result<void>> loadChapters(String courseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // UI может показать индикатор загрузки

    final result = await _repository.getChapters(courseId);
    
    switch(result) {
      case Ok():
        _chapters = result.value;
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