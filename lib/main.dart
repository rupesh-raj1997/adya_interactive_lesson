import 'package:adya_interactive_lesson/lesson/interactive.dart';
import 'package:flutter/material.dart';
// import 'package:adya_interactive_lesson/lesson/normal.dart';

void main() {
  print('########################################################');
  const lessonId = 1;
  // final Lesson interactiveLesson = fetchLesson(userId);
  // Chapter lessonStart = interactiveLesson.lessonStart;
  // interactiveLesson.printLesson(lessonStart);
  print('########################################################');
  runApp(
    const MaterialApp(
      title: 'Adya Interactive Lesson',
      home: InteractiveLesson(lessonId: lessonId),
    ),
  );
}
