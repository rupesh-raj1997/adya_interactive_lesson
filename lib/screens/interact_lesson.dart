import 'package:adya_interactive_lesson/services/blocs/lesson/lesson_bloc.dart';
import 'package:adya_interactive_lesson/widgets/button.dart';
import 'package:adya_interactive_lesson/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class InteractLesson extends StatelessWidget {
  const InteractLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // video player
        SizedBox(
          width: MediaQuery.of(context).size.width + 10,
          height: MediaQuery.of(context).size.height / 3,
          child: BlocBuilder<LessonBloc, LessonState>(
            builder: (context, state) {
              return state.isLessonLoaded
                  ? AspectRatio(
                      aspectRatio: state.controller.value.aspectRatio,
                      child: VideoPlayer(state.controller),
                    )
                  : circularLoader();
            },
          ),
        ),
        //  video progress bar
        BlocBuilder<LessonBloc, LessonState>(
          buildWhen: (previous, current) {
            return (previous.currentProgress != current.currentProgress);
          },
          builder: (context, state) {
            return Slider(
              min: 0,
              max: state.lessonDuration,
              value: state.currentProgress,
              onChanged: (val) {},
              onChangeStart: (val) {},
              onChangeEnd: (val) => {},
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //   controls
            BlocBuilder<LessonBloc, LessonState>(
              builder: (context, state) {
                return Row(
                  key: Key('${state.controller.value.isPlaying}'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: PrimaryButton(
                        onPressed: () {
                          // BlocProvider.of<LessonBloc>(context).add(SeekLesson(-10.0));
                        },
                        child: const Text(
                          '-10',
                          style: btnFontStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: PrimaryButton(
                        onPressed: () {
                          print('button clicked');
                          print(state.controller.value.isPlaying);
                          if (state.controller.value.isPlaying) {
                            context.read<LessonBloc>().add(PauseChapter());
                          } else {
                            context.read<LessonBloc>().add(StartChapter());
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: PrimaryButton(
                        onPressed: () {
                          // BlocProvider.of<LessonBloc>(context).add(SeekLesson(10.0));
                        },
                        child: const Text(
                          '+10',
                          style: btnFontStyle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            // name and chapter number
            chapterDetails(),
            // const ChapterQuestionnaire(),
          ],
        )
      ],
    );
  }
}

Widget chapterDetails() {
  const nameDescStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  return BlocBuilder<LessonBloc, LessonState>(
    builder: (context, state) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isCurrChapterDone) ...[
                  Text(
                    '${state.currentChapter.data.videometa.choicebreakpoint?.question}',
                  ),
                  if (state.currentChapter.data.videometa.choicebreakpoint!
                      .choices.isNotEmpty)
                    for (var choice in state.currentChapter.data.videometa
                        .choicebreakpoint!.choices)
                      Material(
                        color: Colors.black,
                        child: RadioListTile(
                          title: Text(
                            choice.label,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
