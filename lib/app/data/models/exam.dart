enum ExamTaskType {
  wordCatcher,
  translationMatchArena,
  sentenceBuilderRunner,
  gapFillDungeon,
  pronunciationRhythm,
  memoryCards,
  wordDefense,
  dialogueQuest,
  spellingArcade,
  grammarSorter,
}

class Exam {
  const Exam({
    required this.id,
    required this.title,
    required this.gameTopics,
    required this.tasks,
  });

  final String id;
  final String title;
  final List<ExamGameTopic> gameTopics;
  final List<ExamTask> tasks;

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      title: json['title'] as String,
      gameTopics: (json['gameTopics'] as List<dynamic>)
          .map((topic) => ExamGameTopic.fromJson(topic as Map<String, dynamic>))
          .toList(),
      tasks: (json['tasks'] as List<dynamic>)
          .map((task) => ExamTask.fromJson(task as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExamGameTopic {
  const ExamGameTopic({
    required this.id,
    required this.name,
    this.position,
  });

  final String id;
  final String name;
  final int? position;

  factory ExamGameTopic.fromJson(Map<String, dynamic> json) {
    return ExamGameTopic(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as int?,
    );
  }
}

class ExamTask {
  const ExamTask({
    required this.id,
    required this.type,
    required this.title,
    required this.prompt,
    required this.topicId,
    this.left = const [],
    this.right = const [],
    this.options = const [],
    this.targets = const [],
    this.pairs = const {},
    this.sequence = const [],
    this.template = '',
    this.answer = '',
    this.category = '',
    this.correctIds = const [],
  });

  final String id;
  final ExamTaskType type;
  final String title;
  final String prompt;
  final String topicId;
  final List<ExamChoice> left;
  final List<ExamChoice> right;
  final List<ExamChoice> options;
  final List<ExamChoice> targets;
  final Map<String, String> pairs;
  final List<String> sequence;
  final String template;
  final String answer;
  final String category;
  final List<String> correctIds;

  factory ExamTask.fromJson(Map<String, dynamic> json) {
    return ExamTask(
      id: json['id'] as String,
      type: _typeFromJson(json['type'] as String),
      title: json['title'] as String,
      prompt: json['prompt'] as String,
      topicId: json['topicId'] as String,
      left: _choices(json['left']),
      right: _choices(json['right']),
      options: _choices(json['options']),
      targets: _choices(json['targets']),
      pairs: (json['pairs'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, value as String),
      ),
      sequence: (json['sequence'] as List<dynamic>? ?? [])
          .map((value) => value as String)
          .toList(),
      template: json['template'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? '',
      correctIds: (json['correctIds'] as List<dynamic>? ?? [])
          .map((value) => value as String)
          .toList(),
    );
  }

  static List<ExamChoice> _choices(Object? json) {
    return (json as List<dynamic>? ?? [])
        .map((choice) => ExamChoice.fromJson(choice as Map<String, dynamic>))
        .toList();
  }

  static ExamTaskType _typeFromJson(String value) {
    return ExamTaskType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ExamTaskType.wordCatcher,
    );
  }
}

class ExamChoice {
  const ExamChoice({
    required this.id,
    required this.text,
    this.group,
  });

  final String id;
  final String text;
  final String? group;

  factory ExamChoice.fromJson(Map<String, dynamic> json) {
    return ExamChoice(
      id: json['id'] as String,
      text: json['text'] as String,
      group: json['group'] as String?,
    );
  }
}
