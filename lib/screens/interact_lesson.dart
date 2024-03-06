import 'package:adya_interactive_lesson/services/blocs/lesson_bloc.dart';
import 'package:adya_interactive_lesson/services/generate_lesson.dart';
import 'package:adya_interactive_lesson/widgets/button.dart';
import 'package:adya_interactive_lesson/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class InteractLesson extends StatefulWidget {
  const InteractLesson({super.key});

  @override
  State<InteractLesson> createState() => _InteractLessonState();
}

class _InteractLessonState extends State<InteractLesson> {
  final bloc = LessonBloc(loadLesson());

  @override
  void initState() {
    super.initState(); //
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: BlocProvider(
      create: (context) => bloc,
      child: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          print('state duration ${state.currentPosition}'); //
          if (!state.canStartLesson) {
            BlocProvider.of<LessonBloc>(context).add(LessonInitializing());
          }
          return Column(
            children: [
              // video player
              SizedBox(
                width: MediaQuery.of(context).size.width + 10,
                height: MediaQuery.of(context).size.height / 3,
                child: (state.canStartLesson &&
                        state.canStartChapter &&
                        state.controller.value.isInitialized)
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
                value: state.currentPosition,
                onChanged: (val) {},
                onChangeStart: (val) {},
                onChangeEnd: (val) => {},
              ),
              //   controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: PrimaryButton(
                      onPressed: () {
                        BlocProvider.of<LessonBloc>(context)
                            .add(SeekLesson(-10.0));
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
                          if (state.isPlaying) {
                            BlocProvider.of<LessonBloc>(context)
                                .add(PauseChapter());
                          } else {
                            BlocProvider.of<LessonBloc>(context)
                                .add(StartChapter());
                          }
                        },
                        child: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: PrimaryButton(
                      onPressed: () {
                        BlocProvider.of<LessonBloc>(context)
                            .add(SeekLesson(10.0));
                      },
                      child: const Text(
                        '+10',
                        style: btnFontStyle,
                      ),
                    ),
                  ),
                ],
              ),

              // name and chapter number
              // description
            ],
          );
        },
      ),
    ));
  }
}
