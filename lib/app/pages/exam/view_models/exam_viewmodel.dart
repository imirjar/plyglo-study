import 'package:flutter/foundation.dart';
import 'package:poliglotim/app/data/models/exam.dart';
import 'package:poliglotim/app/data/repositories/exam_repository.dart';

class ExamViewModel extends ChangeNotifier {
  ExamViewModel({ExamRepository? repository})
      : _repository = repository ?? ExamRepository();

  final ExamRepository _repository;

  Exam? _exam;
  bool _isLoading = false;
  String? _error;
  int _selectedIndex = 0;
  int _completedCount = 0;

  Exam? get exam => _exam;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedIndex => _selectedIndex;
  int get completedCount => _completedCount;

  ExamTask? get selectedTask {
    final exam = _exam;
    if (exam == null || exam.tasks.isEmpty) return null;
    return exam.tasks[_selectedIndex.clamp(0, exam.tasks.length - 1)];
  }

  Future<void> loadExam() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exam = await _repository.getExam();
      _selectedIndex = 0;
      _completedCount = 0;
    } on Exception catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectTask(int index) {
    final exam = _exam;
    if (exam == null || index < 0 || index >= exam.tasks.length) return;
    _selectedIndex = index;
    notifyListeners();
  }

  void completeSelectedTask() {
    _completedCount += 1;
    final exam = _exam;
    if (exam != null && _selectedIndex < exam.tasks.length - 1) {
      _selectedIndex += 1;
    }
    notifyListeners();
  }
}
