import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:poliglotim/app/data/models/exam.dart';

class ExamFlameGame extends FlameGame {
  ExamFlameGame({
    required this.task,
    required this.onCompleted,
    required this.isDark,
  });

  final ExamTask task;
  final VoidCallback onCompleted;
  final bool isDark;

  final Set<String> _solved = {};
  final Random _random = Random(4);
  String? _selectedId;
  String _builtText = '';
  int _score = 0;
  int _misses = 0;
  int _step = 0;
  bool _completed = false;
  late TextComponent _status;
  final Map<String, TextComponent> _labels = {};

  Color get _surface =>
      isDark ? const Color(0xFF1D222B) : const Color(0xFFF7F8FA);
  Color get _ink => isDark ? const Color(0xFFF2F5F8) : const Color(0xFF20242A);
  Color get _muted =>
      isDark ? const Color(0xFF9AA8B7) : const Color(0xFF657282);
  Color get _accent => const Color(0xFF2E7DFF);
  Color get _good => const Color(0xFF20A464);
  Color get _bad => const Color(0xFFE45050);

  @override
  Color backgroundColor() => _surface;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _build();
  }

  void _build() {
    removeAll(children);
    _solved.clear();
    _selectedId = null;
    _builtText = '';
    _score = 0;
    _misses = 0;
    _step = 0;
    _completed = false;
    _labels.clear();

    add(
      TextComponent(
        text: task.prompt,
        position: Vector2(24, 22),
        textRenderer: TextPaint(
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
    _status = TextComponent(
      text: '',
      position: Vector2(24, 54),
      textRenderer: TextPaint(
        style: TextStyle(color: _muted, fontSize: 13),
      ),
    );
    add(_status);

    switch (task.type) {
      case ExamTaskType.wordCatcher:
        _buildTargetTapping(category: task.category, verb: 'Поймано');
      case ExamTaskType.translationMatchArena:
        _buildMatching();
      case ExamTaskType.sentenceBuilderRunner:
        _buildSequenceRunner();
      case ExamTaskType.gapFillDungeon:
        _buildSingleAnswer();
      case ExamTaskType.pronunciationRhythm:
        _buildRhythm();
      case ExamTaskType.memoryCards:
        _buildMemory();
      case ExamTaskType.wordDefense:
        _buildTargetTapping(category: task.category, verb: 'Остановлено');
      case ExamTaskType.dialogueQuest:
        _buildSingleAnswer();
      case ExamTaskType.spellingArcade:
        _buildSpelling();
      case ExamTaskType.grammarSorter:
        _buildGrammarSorter();
    }
    _refreshStatus();
  }

  void _buildTargetTapping({required String category, required String verb}) {
    _addLabel('Цель: $category', Vector2(24, 88));
    for (var i = 0; i < task.targets.length; i++) {
      final target = task.targets[i];
      final x = 34 + (i % 2) * 180.0;
      final y = 128 + (i ~/ 2) * 74.0;
      add(
        _GameButton(
          text: target.text,
          position: Vector2(x, y),
          size: Vector2(150, 48),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            if (_solved.contains(target.id)) return;
            if (target.group == category) {
              _solved.add(target.id);
              _score += 1;
              _flash('$verb: ${target.text}', _good);
              if (_solved.length == _targetsInCategory(category)) _finish();
            } else {
              _misses += 1;
              _flash('Это ${target.group ?? 'другая категория'}', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  int _targetsInCategory(String category) {
    return task.targets.where((target) => target.group == category).length;
  }

  void _buildMatching() {
    _addLabel('Выбери карточку слева, затем пару справа', Vector2(24, 88));
    for (var i = 0; i < task.left.length; i++) {
      final choice = task.left[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(34, 128 + i * 62.0),
          size: Vector2(170, 46),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            _selectedId = choice.id;
            _flash('Выбрано: ${choice.text}', _accent);
          },
        ),
      );
    }

    for (var i = 0; i < task.right.length; i++) {
      final choice = task.right[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(260, 128 + i * 62.0),
          size: Vector2(170, 46),
          fill: _cardFill(i + 3),
          ink: _ink,
          onPressed: () {
            final selected = _selectedId;
            if (selected == null || _solved.contains(selected)) return;
            if (task.pairs[selected] == choice.id) {
              _solved.add(selected);
              _score += 1;
              _selectedId = null;
              _flash('Пара найдена', _good);
              if (_solved.length == task.pairs.length) _finish();
            } else {
              _misses += 1;
              _flash('Попробуй другую пару', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _buildSequenceRunner() {
    _addLabel('Собрано: $_builtText', Vector2(24, 92), keyName: 'built');
    for (var i = 0; i < task.options.length; i++) {
      final choice = task.options[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(34 + (i % 2) * 190.0, 142 + (i ~/ 2) * 68.0),
          size: Vector2(160, 48),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            if (_step >= task.sequence.length) return;
            if (choice.text == task.sequence[_step]) {
              _step += 1;
              _score += 1;
              _builtText = task.sequence.take(_step).join(' ');
              _flash(_builtText, _good);
              _replaceLabel('built', 'Собрано: $_builtText');
              if (_step == task.sequence.length) _finish();
            } else {
              _misses += 1;
              _flash('Нужное слово сейчас: ${task.sequence[_step]}', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _buildSingleAnswer() {
    _addLabel(task.template.isEmpty ? 'Выбери ответ' : task.template,
        Vector2(24, 92));
    for (var i = 0; i < task.options.length; i++) {
      final choice = task.options[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(34 + (i % 3) * 145.0, 150 + (i ~/ 3) * 68.0),
          size: Vector2(118, 48),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            if (choice.id == task.answer || choice.text == task.answer) {
              _score += 1;
              _flash('Верно', _good);
              _finish();
            } else {
              _misses += 1;
              _flash('Не эта дверь', _bad);
              _refreshStatus();
            }
          },
        ),
      );
    }
  }

  void _buildRhythm() {
    _addLabel('Ритм: ${task.sequence.join(' - ')}', Vector2(24, 92));
    for (var i = 0; i < task.options.length; i++) {
      final choice = task.options[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(54 + i * 122.0, 156 + sin(i) * 14.0),
          size: Vector2(86, 86),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            if (_step >= task.sequence.length) return;
            if (choice.text == task.sequence[_step]) {
              _step += 1;
              _score += 1;
              _flash('Beat $_step', _good);
              if (_step == task.sequence.length) _finish();
            } else {
              _misses += 1;
              _flash('Слушай ритм внимательнее', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _buildMemory() {
    final cards = [...task.left, ...task.right]..shuffle(_random);
    _addLabel('Открой две карточки и найди пару', Vector2(24, 88));
    for (var i = 0; i < cards.length; i++) {
      final choice = cards[i];
      add(
        _MemoryCard(
          choice: choice,
          position: Vector2(34 + (i % 3) * 136.0, 130 + (i ~/ 3) * 72.0),
          fill: _cardFill(i),
          ink: _ink,
          onOpened: (card) {
            if (_selectedId == null) {
              _selectedId = card.choice.id;
              _flash('Открыто: ${card.choice.text}', _accent);
              return;
            }
            final left = _selectedId!;
            final right = card.choice.id;
            if (task.pairs[left] == right || task.pairs[right] == left) {
              _solved.add(left);
              _solved.add(right);
              _score += 1;
              _selectedId = null;
              _flash('Память работает', _good);
              if (_solved.length == cards.length) _finish();
            } else {
              _misses += 1;
              _selectedId = null;
              _flash('Не пара', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _buildSpelling() {
    _addLabel('Слово: $_builtText', Vector2(24, 92), keyName: 'built');
    for (var i = 0; i < task.options.length; i++) {
      final choice = task.options[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(38 + i * 82.0, 150 + (i.isEven ? 0 : 28)),
          size: Vector2(60, 60),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            final next = _builtText.length;
            if (next < task.answer.length && choice.text == task.answer[next]) {
              _builtText += choice.text;
              _score += 1;
              _replaceLabel('built', 'Слово: $_builtText');
              _flash(_builtText, _good);
              if (_builtText == task.answer) _finish();
            } else {
              _misses += 1;
              _flash('Буква не подходит', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _buildGrammarSorter() {
    _addLabel('Выбери слово, затем корзину', Vector2(24, 88));
    for (var i = 0; i < task.targets.length; i++) {
      final choice = task.targets[i];
      add(
        _GameButton(
          text: choice.text,
          position: Vector2(34, 130 + i * 58.0),
          size: Vector2(170, 44),
          fill: _cardFill(i),
          ink: _ink,
          onPressed: () {
            _selectedId = choice.id;
            _flash('Слово: ${choice.text}', _accent);
          },
        ),
      );
    }
    for (var i = 0; i < task.options.length; i++) {
      final bin = task.options[i];
      add(
        _GameButton(
          text: bin.text,
          position: Vector2(260, 130 + i * 58.0),
          size: Vector2(150, 44),
          fill: _cardFill(i + 5),
          ink: _ink,
          onPressed: () {
            final selected = _selectedId;
            if (selected == null || _solved.contains(selected)) return;
            final word =
                task.targets.firstWhere((target) => target.id == selected);
            if (word.group == bin.id) {
              _solved.add(selected);
              _score += 1;
              _selectedId = null;
              _flash('В корзине ${bin.text}', _good);
              if (_solved.length == task.targets.length) _finish();
            } else {
              _misses += 1;
              _flash('Это не ${bin.text}', _bad);
            }
            _refreshStatus();
          },
        ),
      );
    }
  }

  void _finish() {
    if (_completed) return;
    _completed = true;
    _flash('Задание завершено', _good);
    add(
      _GameButton(
        text: 'Следующая игра',
        position: Vector2(24, max(size.y - 72, 300)),
        size: Vector2(180, 48),
        fill: _good,
        ink: Colors.white,
        onPressed: onCompleted,
      ),
    );
  }

  void _refreshStatus() {
    _status.text = 'Очки: $_score   Ошибки: $_misses';
  }

  void _flash(String text, Color color) {
    final component = TextComponent(
      text: text,
      position: Vector2(24, max(size.y - 112, 260)),
      textRenderer: TextPaint(
        style:
            TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
    add(component);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      component.removeFromParent();
    });
  }

  void _addLabel(String text, Vector2 position, {String? keyName}) {
    final label = TextComponent(
      text: text,
      position: position,
      textRenderer: TextPaint(style: TextStyle(color: _ink, fontSize: 16)),
    );
    if (keyName != null) _labels[keyName] = label;
    add(label);
  }

  void _replaceLabel(String keyName, String text) {
    final component = _labels[keyName];
    if (component != null) component.text = text;
  }

  Color _cardFill(int index) {
    const light = [
      Color(0xFFFFFFFF),
      Color(0xFFEAF2FF),
      Color(0xFFEFF8F1),
      Color(0xFFFFF4E2),
      Color(0xFFF4ECFF),
      Color(0xFFEAF8F8),
    ];
    const dark = [
      Color(0xFF29313D),
      Color(0xFF213651),
      Color(0xFF1F3D2D),
      Color(0xFF46351F),
      Color(0xFF382B4D),
      Color(0xFF223B3F),
    ];
    final palette = isDark ? dark : light;
    return palette[index % palette.length];
  }
}

class _GameButton extends PositionComponent with TapCallbacks {
  _GameButton({
    required this.text,
    required Vector2 position,
    required Vector2 size,
    required this.fill,
    required this.ink,
    required this.onPressed,
  }) : super(position: position, size: size);

  final String text;
  final Color fill;
  final Color ink;
  final VoidCallback onPressed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = fill,
      ),
    );
    add(
      TextComponent(
        text: text,
        anchor: Anchor.center,
        position: size / 2,
        textRenderer: TextPaint(
          style:
              TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
  }
}

class _MemoryCard extends PositionComponent with TapCallbacks {
  _MemoryCard({
    required this.choice,
    required Vector2 position,
    required this.fill,
    required this.ink,
    required this.onOpened,
  }) : super(position: position, size: Vector2(112, 52));

  final ExamChoice choice;
  final Color fill;
  final Color ink;
  final void Function(_MemoryCard card) onOpened;
  bool _opened = false;
  late TextComponent _text;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleComponent(size: size, paint: Paint()..color = fill));
    _text = TextComponent(
      text: '?',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
    add(_text);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_opened) return;
    _opened = true;
    _text.text = choice.text;
    onOpened(this);
  }
}
