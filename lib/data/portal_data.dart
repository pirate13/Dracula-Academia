import 'package:flutter/material.dart';

class StudyTask {
  const StudyTask({required this.title, required this.subject, required this.deadline, required this.details, required this.icon});
  final String title;
  final String subject;
  final DateTime deadline;
  final String details;
  final IconData icon;
}

final demoTasks = <StudyTask>[
  StudyTask(title: 'Мобільний застосунок', subject: 'Мобільна розробка', deadline: DateTime(2026, 12, 3), details: 'Створити чотири екрани та налаштувати навігацію.', icon: Icons.phone_iphone_rounded),
  StudyTask(title: 'Лабораторна робота № 3', subject: 'Хмарні технології', deadline: DateTime(2026, 12, 8), details: 'Підготувати звіт і скриншоти виконання.', icon: Icons.cloud_outlined),
  StudyTask(title: 'Проєкт з баз даних', subject: 'Бази даних', deadline: DateTime(2026, 12, 12), details: 'Створити структуру таблиць і приклади запитів.', icon: Icons.storage_rounded),
  StudyTask(title: 'Підготовка до модулю', subject: 'Програмування', deadline: DateTime(2026, 12, 18), details: 'Повторити основні теми та практичні завдання.', icon: Icons.menu_book_rounded),
];

class Habit {
  const Habit(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

const habits = <Habit>[
  Habit('Випити воду', 'Склянка води під час навчання', Icons.water_drop_outlined),
  Habit('Зробити перерву', 'Встати й пройтися кілька хвилин', Icons.free_breakfast_outlined),
  Habit('Відпочинок для очей', 'Подивитися вдалину на 20 секунд', Icons.visibility_outlined),
  Habit('Трохи розім’ятися', 'Легкі рухи для шиї та плечей', Icons.self_improvement_outlined),
];
