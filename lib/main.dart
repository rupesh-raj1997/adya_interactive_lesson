import 'package:adya_interactive_lesson/services/blocs/lesson/lesson_bloc.dart';
import 'package:adya_interactive_lesson/services/generate_lesson.dart';
import 'package:flutter/material.dart';
import 'package:adya_interactive_lesson/screens/interact_lesson.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  LessonBloc lessonBloc = LessonBloc(loadLesson());
  lessonBloc.add(LessonInitializing());
  runApp(
    BlocProvider(
      create: (context) =>lessonBloc,
      lazy: false,
      child: MaterialApp(
        title: 'Adya Interactive Lesson',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Interactive Lesson Demo'),
          ),
          body: const InteractLesson(),
        ),
      ),
    ),
  );
}
