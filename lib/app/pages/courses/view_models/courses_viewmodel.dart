import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:poliglotim/app/core/result.dart';
import 'package:poliglotim/app/data/models/course.dart';
import 'package:poliglotim/app/data/repositories/course_repository.dart';

class CoursesViewModel with ChangeNotifier {
  final CourseRepository repository = CourseRepository();
  final _log = Logger('CoursesViewModel');

  // CoursesViewModel({
  //   required CourseRepository courseRepository,
  // }) : _repository = courseRepository;

  // State
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Result<void>> getCourses() async {
    // 1. Устанавливаем состояние "загрузка"
    _isLoading = true;
    _error = null;
    notifyListeners(); // UI показывает индикатор загрузки

    final result = await repository.getCourses();

    // 2. Обрабатываем результат
    switch (result) {
      case Ok():
        _courses = result.value;
      case Error():
        _error = result.error.toString(); // СОХРАНЯЕМ ошибку для UI
        _log.warning("Failed to load courses: ${result.error}");
    }

    // 3. Сбрасываем флаг загрузки и уведомляем ВСЕХ слушателей
    _isLoading = false;
    notifyListeners(); // UI обновляется в любом случае

    // 4. Возвращаем результат (это важно!)
    return result;
  }

  // Метод для повторной попытки (опционально, но очень полезно)
  Future<void> retry() async {
    _error = null; // Сбрасываем ошибку перед повторной попыткой
    notifyListeners();
    await getCourses();
  }
}
