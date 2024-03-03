import 'package:adya_interactive_lesson/lesson/interactive.dart';
import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/services/generate_lesson.dart';
import 'package:flutter/material.dart';
// import 'package:adya_interactive_lesson/lesson/normal.dart';

void main() {
  print('########################################################');
  int userId = 1;
  Lesson interactiveLesson = fetchLesson(userId);
  Chapter lessonStart = interactiveLesson.lessonStart;
  interactiveLesson.printLesson(lessonStart);
  print('########################################################');
  runApp(
    const MaterialApp(
      title: 'Adya Interactive Lesson',
      home: VideoPlayerScreen(),
    ),
  );
}
