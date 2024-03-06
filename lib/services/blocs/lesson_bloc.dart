import 'dart:math';

import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';
import 'package:adya_interactive_lesson/utils/converters.dart';
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
  double currentPosition = 0.0;
  final List<Chapter> completedChapters = [];
  final Map<Chapter, Choice> selectedChoices = {};

  LessonState(this._lesson) {
    canStartLesson = false;
    controller = VideoPlayerController.networkUrl(
      Uri.parse(_lesson.lessonStart.videoURL),
    );
    controller.addListener(() {
      currentPosition = controller.value.position.inSeconds.toDouble();
      // print('state position ${controller.value.position.inSeconds.toDouble()}');
    });
  }

  bool get isPlaying => controller.value.isPlaying;
  bool get isInitialized => controller.value.isInitialized;

  double get lessonDuration {
    List<double> sums = pathSum(findAllPaths(_lesson.lessonStart));
    return sums.reduce((value, element) => value + element) / sums.length;
  }


  List<List> findAllPaths(Chapter root) {
    List<List> paths = [];
    void dfs(Chapter chapter, List<dynamic> path) {
      path.add(chapter.data.videometa.duration);

      if (chapter.children.isEmpty) {
        paths.add(List.from(path));
      } else {
        for (var child in chapter.children) {
          dfs(child, path);
        }
      }
      path.removeLast();
    }

    dfs(root, []);
    return paths;
  }

  @override
  List<Object> get props => [
        _lesson,
        completedChapters,
        selectedChoices,
        canStartChapter,
        canStartLesson,
      ];

  @override
  String toString() {
    return 'state $currentPosition currentPosition $lessonDuration lessonDuration $controller';
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
