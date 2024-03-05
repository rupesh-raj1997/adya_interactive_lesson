import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

@immutable
sealed class LessonEvent {}

// Available Events for Lesson
final class LessonInitializing extends LessonEvent {} // init

final class LessonInitalized extends LessonEvent {}

final class StartChapter extends LessonEvent {} // hit play button

final class PauseChapter extends LessonEvent {} // hit pause button

final class RestartLesson extends LessonEvent {} // restart lesson

final class SeekLesson extends LessonEvent {
  final double amount;
  SeekLesson(this.amount);
} // move to a specific time

class LessonState extends Equatable {
  final Lesson _lesson;
  late VideoPlayerController controller;
  bool canStartChapter = false;
  bool canStartLesson = false;
  final List<Chapter> completedChapters = [];
  final Map<Chapter, Choice> selectedChoices = {};

  LessonState(this._lesson) {
    canStartLesson = false;
    controller = VideoPlayerController.networkUrl(
      Uri.parse(_lesson.lessonStart.videoURL),
    );
  }

  bool get isPlaying => controller.value.isPlaying;
  bool get isInitialized => controller.value.isInitialized;
  Duration get currPosition => controller.value.position;

  @override
  List<Object> get props => [
        _lesson,
        completedChapters,
        selectedChoices,
        canStartChapter,
        canStartLesson
      ];

  @override
  String toString() {
    // TODO: implement toString
    return 'state canStartChapter $canStartChapter canStartLesson $canStartLesson controller $controller';
  }
}

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc(lesson) : super(LessonState(lesson)) {
    on<LessonEvent>((event, emit) async {
      if (event is LessonInitializing) {
        await state.controller.initialize();
        state.canStartLesson = true;
        state.canStartChapter = true;
        return;
      } else if (event is StartChapter) {
        state.controller.play();
      } else if (event is PauseChapter) {
        state.controller.pause();
      } else if (event is RestartLesson) {
      } else if (event is SeekLesson) {}
    });
  }

  @override
  Future<void> close() {
    // Dispose of the controller when the BLoC is closed
    state.controller?.dispose();
    return super.close();
  }
}
