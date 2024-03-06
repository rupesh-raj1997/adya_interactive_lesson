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
  SaveChapterChoice(this.selectedChoice);
}
final class RestartLesson extends LessonEvent {} // restart lesson

final class ProgressChapter extends LessonEvent {
  final double newPosition;
  ProgressChapter(this.newPosition);
}

final class SeekLesson extends LessonEvent {
  final double amount;
  SeekLesson(this.amount);
} // move to a specific time
