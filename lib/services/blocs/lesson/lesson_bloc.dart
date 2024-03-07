import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:adya_interactive_lesson/utils/common.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc(Lesson lesson) : super(LessonState.usingLesson(lesson: lesson)) {
    _controllerListener() {
      if (state.controller.value.isPlaying) {
        double newProgress =
            state.controller.value.position.inSeconds.toDouble() +
                state.completedChapters.fold(
                  0,
                  (prev, ele) => prev + ele.data.videometa.duration,
                );
        add(ProgressChapter(newProgress));
      }

      if (state.controller.value.isCompleted) {
        // check if completion of this video completes the lesson
        if (state.completedChapters.length ==
            findHeight(state.lesson.lessonStart)) {
          add(CompleteLesson());
        } else {
          add(EndChapter());
        }
      }
    }

    on<LessonInitializing>((event, emit) async {
      print('init $event');
      await state.controller.initialize();
      state.controller.addListener(_controllerListener);
      emit(state.copyWith(isLessonLoaded: true));
    });

    on<StartChapter>((event, emit) async {
      await state.controller.play();
    });

    on<EndChapter>((event, emit) async {
      print('bloc recieved and event $event');
      // At the end of chapter we ask question if we have
      ChoiceBreakPoint choiceBP =
          state.currentChapter.data.videometa.choicebreakpoint!;
      if (choiceBP.question.isNotEmpty && choiceBP.choices.isNotEmpty) {
        emit(state.copyWith(isCurrChapterDone: true));
      } else {
        var newChap = state.currentChapter.children.first;
        var comChaps = List<Chapter>.from(state.completedChapters);
        comChaps.add(state.currentChapter);
        double currProgress = 0.0;
        for (var ele in comChaps) {
          currProgress += ele.data.videometa.duration;
          var newController =
              VideoPlayerController.networkUrl(Uri.parse(newChap.videoURL));
          await newController.initialize();
          newController.addListener(_controllerListener);
          emit(state.copyWith(
            isCurrChapterDone: false,
            controller: newController,
            completedChapters: comChaps,
            currentChapter: newChap,
            currentProgress: currProgress,
          ));
          add(StartChapter());
        }
      }
    });

    on<SaveChapterChoice>((event, emit) async {
      // user has selected a choice we can proceed to next lesson
      Choice sChoice = event.selectedChoice;
      Chapter newChap = state.currentChapter.children.firstWhere((chap) {
        return sChoice.value.contains('${chap.data.videometa.id}');
      });
      List<Chapter> comChaps = List.from(state.completedChapters);
      comChaps.add(state.currentChapter);
      var selChoices = Map<Chapter, Choice>.from(state.selectedChoices);
      selChoices[state.currentChapter] = sChoice;

      double currProgress = 0.0;
      for (var ele in comChaps) {
        currProgress += ele.data.videometa.duration;
      }
      VideoPlayerController newController =
          VideoPlayerController.networkUrl(Uri.parse(newChap.videoURL));
      await newController.initialize();
      newController.addListener(_controllerListener);
      emit(state.copyWith(
        isCurrChapterDone: false,
        controller: newController,
        completedChapters: comChaps,
        selectedChoices: selChoices,
        currentChapter: newChap,
        currentProgress: currProgress,
      ));
      add(StartChapter());
    });

    on<PauseChapter>((event, emit) async {
      await state.controller.pause();
    });

    on<ProgressChapter>((event, emit) async {
      emit(state.copyWith(currentProgress: event.newPosition));
    });

    on<CompleteLesson>((event, emit) async {
      emit(state.copyWith(isLessonCompleted: true));
    });

    on<SeekLesson>((event, emit) async {
      print(event.amount);
    });
  }
}
