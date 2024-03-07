part of 'lesson_bloc.dart';

sealed class LessonEvent extends Equatable {
  const LessonEvent();

  @override
  List<Object> get props => [];
}

// Available Events for Lesson
final class LessonInitializing extends LessonEvent {} // init

final class LessonInitalized extends LessonEvent {}

final class StartChapter extends LessonEvent {} // hit play button
final class EndChapter extends LessonEvent {}
final class PauseChapter extends LessonEvent {} // hit pause button
 // save the choice made at the end of video
final class SaveChapterChoice extends LessonEvent {
  final Choice selectedChoice;
  const SaveChapterChoice(this.selectedChoice);
}
final class RestartLesson extends LessonEvent {} // restart lesson
final class CompleteLesson extends LessonEvent {} 
final class ProgressChapter extends LessonEvent {
  final double newPosition;
  const ProgressChapter(this.newPosition);
}

// move to a specific time
final class SeekLesson extends LessonEvent {
  final double amount;
  const SeekLesson(this.amount);
} 
