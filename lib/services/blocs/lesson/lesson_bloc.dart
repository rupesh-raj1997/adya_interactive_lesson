import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
import 'package:adya_interactive_lesson/utils/converters.dart';

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
        add(EndChapter());
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
      // At the end of chapter we ask question if we have
      ChoiceBreakPoint choiceBP = state.currentChapter.data.videometa.choicebreakpoint!;
      if(choiceBP.question.isNotEmpty && choiceBP.choices.isNotEmpty){
       emit(state.copyWith(isCurrChapterDone: true));
      }
      // if (choiceBreakPoint.choices.isNotEmpty) {
      //   // user has to select to proceed
      // } else {
      //   // user need not make any choice we can mark this chapter complete and next chapter
      //   state.completedChapters.add(state.currentChapter);
      //   Chapter nextChapter = state.currentChapter.children.first;
      //   VideoPlayerController videoPlayerController =
      //       VideoPlayerController.networkUrl(Uri.parse(nextChapter.videoURL));
      //   await videoPlayerController.initialize();
      //   videoPlayerController.addListener(_controllerListener);
      //   emit(state.copyWith(
      //     controller: videoPlayerController,
      //     isLessonLoaded: !state.isLessonLoaded,
      //   ));
      // }
    });

    on<SaveChapterChoice>((event, emit) {
      Map<Chapter, Choice> updatedChoices =  state.selectedChoices;
      updatedChoices[state.currentChapter] = event.selectedChoice;
      emit(state.copyWith(selectedChoices: updatedChoices));
    });

    on<PauseChapter>((event, emit) async {
      await state.controller.pause();
    });

    on<ProgressChapter>((event, emit) async {
      emit(state.copyWith(currentProgress: event.newPosition));
    });
  }
}
