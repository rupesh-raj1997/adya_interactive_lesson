import 'package:flutter/material.dart';
import 'package:adya_interactive_lesson/screens/interact_lesson.dart';

void main() {
  runApp(
    MaterialApp(
      title: ' Adya Interactive Lesson',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Interactive Lesson Demo'),
        ),
        body: const InteractLesson(),
      ),
    ),
  );
}
