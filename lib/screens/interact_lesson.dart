import 'package:adya_interactive_lesson/models/video.dart';
import 'package:adya_interactive_lesson/services/blocs/lesson/lesson_bloc.dart';
import 'package:adya_interactive_lesson/utils/common.dart';
import 'package:adya_interactive_lesson/widgets/button.dart';
import 'package:adya_interactive_lesson/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:restart_app/restart_app.dart';

class InteractLesson extends StatelessWidget {
  const InteractLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(builder: (context, state) {
      return state.isLessonCompleted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Lesson Completed',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green[300]!),
                    ),
                    onPressed: () {
                      Restart.restartApp();
                    },
                    child: const Text(
                      'Restart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // video player
                  SizedBox(
                    width: MediaQuery.of(context).size.width + 10,
                    height: MediaQuery.of(context).size.height / 3,
                    child: state.isLessonLoaded
                        ? AspectRatio(
                            aspectRatio: state.controller.value.aspectRatio,
                            child: VideoPlayer(state.controller),
                          )
                        : circularLoader(),
                  ),
                  //  video progress bar
                  Slider(
                    min: 0,
                    max: state.lessonDuration,
                    value: state.currentProgress,
                    onChanged: (val) {
                      print('slider onChanged $val');
                    },
                    onChangeStart: (val) {
                      print('slider onChangeStart $val');
                    },
                    onChangeEnd: (val) {
                      print('slider onChangeEnd ${val.toStringAsFixed(2)}');
                      context.read<LessonBloc>().add(
                          SeekLesson(double.parse(val.toStringAsFixed(2))));
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //   controls
                      Row(
                        key: Key('${state.controller.value.isPlaying}'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: PrimaryButton(
                              onPressed: () {
                                if (state.controller.value.isPlaying) {
                                  context
                                      .read<LessonBloc>()
                                      .add(PauseChapter());
                                } else {
                                  context
                                      .read<LessonBloc>()
                                      .add(StartChapter());
                                }
                              },
                              child: Icon(
                                state.controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // name and chapter number
                  chapterDetails(),
                  ChapterQuestionnaire(
                    key: Key('${state.isCurrChapterDone}'),
                  ),
                ],
              ),
            );
    });
  }
}

Widget chapterDetails() {
  const nameDescStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  return BlocBuilder<LessonBloc, LessonState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter ${state.completedChapters.length + 1}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Name: ${state.currentChapter.data.videometa.name}',
              style: nameDescStyle,
            ),
            Text(
              'Description: ${state.currentChapter.data.videometa.description}',
              style: nameDescStyle,
            ),
          ],
        ),
      );
    },
  );
}

class ChapterQuestionnaire extends StatefulWidget {
  const ChapterQuestionnaire({
    super.key,
  });

  @override
  State<ChapterQuestionnaire> createState() => _ChapterQuestionnaireState();
}

class _ChapterQuestionnaireState extends State<ChapterQuestionnaire> {
  String selectedChoice = '';
  bool showProceedButton = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            key: Key('${state.isCurrChapterDone}'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.isCurrChapterDone) ...[
                Text(
                  '${state.currentChapter.data.videometa.choicebreakpoint?.question}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                if (state.currentChapter.data.videometa.choicebreakpoint!
                    .choices.isNotEmpty)
                  for (var choice in state
                      .currentChapter.data.videometa.choicebreakpoint!.choices)
                    Material(
                      child: RadioListTile(
                        dense: true,
                        title: Text(
                          choice.label,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: choice.value,
                        groupValue: selectedChoice,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedChoice = value!;
                              showProceedButton = true;
                            },
                          );
                        },
                      ),
                    ),
              ],
              showProceedButton
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.green[300]!),
                          ),
                          onPressed: () {
                            setState(() {
                              ChoiceBreakPoint choiceBP = state.currentChapter
                                  .data.videometa.choicebreakpoint!;
                              if (selectedChoice.isNotEmpty) {
                                Choice reqChoice = choiceBP.choices.firstWhere(
                                    (ele) => ele.value == selectedChoice);
                                context
                                    .read<LessonBloc>()
                                    .add(SaveChapterChoice(reqChoice));
                                setState(() {
                                  // showProceedButton = false;
                                  // selectedChoice = '';
                                });
                              }
                            });
                          },
                          child: const Text(
                            'Procced',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(
                      height: 10.0,
                    )
            ],
          ),
        );
      },
    );
  }
}
