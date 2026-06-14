import 'dart:async';

import 'package:poliglotim/app/data/models/exam.dart';

class ExamRepository {
  Future<Exam> getExam() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return Exam.fromJson(_fakeExamJson);
  }
}

const _fakeExamJson = {
  'id': 'english-a1-games',
  'title': 'English A1 Arcade',
  'gameTopics': [
    {'id': 'vocabulary', 'name': 'Vocabulary', 'position': 1},
    {'id': 'translation', 'name': 'Translation', 'position': 2},
    {'id': 'grammar', 'name': 'Grammar', 'position': 3},
    {'id': 'listening', 'name': 'Rhythm', 'position': 4},
    {'id': 'dialogue', 'name': 'Dialogue', 'position': 5},
  ],
  'tasks': [
    {
      'id': 'word-catcher',
      'topicId': 'vocabulary',
      'type': 'wordCatcher',
      'title': 'Word Catcher',
      'prompt': 'Поймай только фрукты',
      'category': 'fruit',
      'targets': [
        {'id': 'apple', 'text': 'apple', 'group': 'fruit'},
        {'id': 'book', 'text': 'book', 'group': 'object'},
        {'id': 'banana', 'text': 'banana', 'group': 'fruit'},
        {'id': 'chair', 'text': 'chair', 'group': 'object'},
      ],
    },
    {
      'id': 'translation-arena',
      'topicId': 'translation',
      'type': 'translationMatchArena',
      'title': 'Translation Arena',
      'prompt': 'Соедини слово и перевод',
      'left': [
        {'id': 'dog', 'text': 'dog'},
        {'id': 'house', 'text': 'house'},
        {'id': 'water', 'text': 'water'},
      ],
      'right': [
        {'id': 'home', 'text': 'дом'},
        {'id': 'aqua', 'text': 'вода'},
        {'id': 'hound', 'text': 'собака'},
      ],
      'pairs': {'dog': 'hound', 'house': 'home', 'water': 'aqua'},
    },
    {
      'id': 'sentence-runner',
      'topicId': 'grammar',
      'type': 'sentenceBuilderRunner',
      'title': 'Sentence Runner',
      'prompt': 'Собери предложение по порядку',
      'sequence': ['I', 'am', 'learning', 'English'],
      'options': [
        {'id': 'learning', 'text': 'learning'},
        {'id': 'I', 'text': 'I'},
        {'id': 'English', 'text': 'English'},
        {'id': 'am', 'text': 'am'},
      ],
    },
    {
      'id': 'gap-dungeon',
      'topicId': 'grammar',
      'type': 'gapFillDungeon',
      'title': 'Gap Dungeon',
      'prompt': 'Открой дверь правильным словом',
      'template': 'She ___ a teacher.',
      'answer': 'is',
      'options': [
        {'id': 'am', 'text': 'am'},
        {'id': 'is', 'text': 'is'},
        {'id': 'are', 'text': 'are'},
      ],
    },
    {
      'id': 'rhythm',
      'topicId': 'listening',
      'type': 'pronunciationRhythm',
      'title': 'Pronunciation Rhythm',
      'prompt': 'Тапни слоги слова banana',
      'sequence': ['ba', 'na', 'na'],
      'options': [
        {'id': 'ba', 'text': 'ba'},
        {'id': 'na1', 'text': 'na'},
        {'id': 'na2', 'text': 'na'},
      ],
    },
    {
      'id': 'memory',
      'topicId': 'translation',
      'type': 'memoryCards',
      'title': 'Memory Cards',
      'prompt': 'Найди пары',
      'left': [
        {'id': 'cat', 'text': 'cat'},
        {'id': 'sun', 'text': 'sun'},
        {'id': 'red', 'text': 'red'},
      ],
      'right': [
        {'id': 'cat-ru', 'text': 'кот'},
        {'id': 'sun-ru', 'text': 'солнце'},
        {'id': 'red-ru', 'text': 'красный'},
      ],
      'pairs': {'cat': 'cat-ru', 'sun': 'sun-ru', 'red': 'red-ru'},
    },
    {
      'id': 'defense',
      'topicId': 'vocabulary',
      'type': 'wordDefense',
      'title': 'Word Defense',
      'prompt': 'Останови только глаголы',
      'category': 'verb',
      'targets': [
        {'id': 'run', 'text': 'run', 'group': 'verb'},
        {'id': 'blue', 'text': 'blue', 'group': 'adjective'},
        {'id': 'read', 'text': 'read', 'group': 'verb'},
        {'id': 'table', 'text': 'table', 'group': 'noun'},
      ],
    },
    {
      'id': 'dialogue',
      'topicId': 'dialogue',
      'type': 'dialogueQuest',
      'title': 'Dialogue Quest',
      'prompt': 'NPC: How are you?',
      'answer': 'fine',
      'options': [
        {'id': 'bye', 'text': 'Good night'},
        {'id': 'fine', 'text': 'I am fine, thanks'},
        {'id': 'age', 'text': 'I am ten'},
      ],
    },
    {
      'id': 'spelling',
      'topicId': 'vocabulary',
      'type': 'spellingArcade',
      'title': 'Spelling Arcade',
      'prompt': 'Собери слово: яблоко',
      'answer': 'apple',
      'options': [
        {'id': 'p1', 'text': 'p'},
        {'id': 'a', 'text': 'a'},
        {'id': 'l', 'text': 'l'},
        {'id': 'e', 'text': 'e'},
        {'id': 'p2', 'text': 'p'},
      ],
    },
    {
      'id': 'grammar',
      'topicId': 'grammar',
      'type': 'grammarSorter',
      'title': 'Grammar Sorter',
      'prompt': 'Отправь слова по частям речи',
      'targets': [
        {'id': 'quickly', 'text': 'quickly', 'group': 'adverb'},
        {'id': 'beautiful', 'text': 'beautiful', 'group': 'adjective'},
        {'id': 'swim', 'text': 'swim', 'group': 'verb'},
      ],
      'options': [
        {'id': 'verb', 'text': 'verb'},
        {'id': 'adjective', 'text': 'adjective'},
        {'id': 'adverb', 'text': 'adverb'},
      ],
    },
  ],
};
