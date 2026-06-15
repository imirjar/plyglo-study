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
  int _selectedTopicIndex = 0;
  int _selectedTaskIndex = 0;
  int _completedCount = 0;

  Exam? get exam => _exam;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedTopicIndex => _selectedTopicIndex;
  int get selectedTaskIndex => _selectedTaskIndex;
  int get completedCount => _completedCount;

  ExamGameTopic? get selectedTopic {
    final exam = _exam;
    if (exam == null || exam.gameTopics.isEmpty) return null;
    return exam
        .gameTopics[_selectedTopicIndex.clamp(0, exam.gameTopics.length - 1)];
  }

  List<ExamTask> get selectedTopicTasks {
    final topic = selectedTopic;
    final exam = _exam;
    if (topic == null || exam == null) return [];
    return exam.tasks.where((task) => task.topicId == topic.id).toList();
  }

  ExamTask? get selectedTask {
    final tasks = selectedTopicTasks;
    if (tasks.isEmpty) return null;
    return tasks[_selectedTaskIndex.clamp(0, tasks.length - 1)];
  }

  Future<void> loadExam() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exam = await _repository.getExam();
      _selectedTopicIndex = 0;
      _selectedTaskIndex = 0;
      _completedCount = 0;
    } on Exception catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectTopic(String topicId) {
    final exam = _exam;
    if (exam == null) return;
    final index = exam.gameTopics.indexWhere((topic) => topic.id == topicId);
    if (index == -1) return;
    _selectedTopicIndex = index;
    _selectedTaskIndex = 0;
    notifyListeners();
  }

  void selectTask(ExamTask task) {
    final index = selectedTopicTasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _selectedTaskIndex = index;
    notifyListeners();
  }

  void completeSelectedTask() {
    _completedCount += 1;
    final tasks = selectedTopicTasks;
    if (_selectedTaskIndex < tasks.length - 1) {
      _selectedTaskIndex += 1;
    }
    notifyListeners();
  }
}
