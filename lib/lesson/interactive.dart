import 'package:adya_interactive_lesson/models/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/services/generate_lesson.dart';

class InteractiveLesson extends StatefulWidget {
  final int lessonId;
  const InteractiveLesson({super.key, required this.lessonId});

  @override
  _InteractiveLessonState createState() => _InteractiveLessonState();
}

class _InteractiveLessonState extends State<InteractiveLesson> {
  Lesson? lesson;
  Chapter? currentChapter;
  int chapterIndex = 0;
  late VideoPlayerController _controller;
  late Future<void>? _initializeVideoPlayerFuture;

  String chapterName = '';
  String chapterDesc = '';
  late ChoiceBreakPoint? chapterBreakPoint;

  bool showChoices = false;
  String selectedChoice = '';
  bool showProceedButton = false;
  Map<String, dynamic> choiceData = {};

  //The values that are passed when changing quality
  late Duration newCurrentPosition;

  setupLessonContent(lessonId) {
    setState(() {
      lesson = fetchLesson(lessonId);
      currentChapter = lesson?.lessonStart;
      chapterIndex = 0;
      chapterName = '${currentChapter?.data.videometa.name}';
      chapterDesc = '${currentChapter?.data.videometa.description}';
      chapterBreakPoint = currentChapter?.data.videometa.choicebreakpoint;
    });
  }

  changeChapter(chapterNumber) {
    Chapter? newChapter;
    switch (chapterNumber) {
      case 0:
        print('moving to project planning');
        newChapter = currentChapter?.children.firstWhere(
          (chapter) => selectedChoice.contains('${chapter.data.videometa.id}'),
        );
        break;
      case 1:
        print('moving to project implementation');
        break;
    }
    setState(() {
      currentChapter = newChapter;
      chapterName = '${currentChapter?.data.videometa.name}';
      chapterDesc = '${currentChapter?.data.videometa.description}';
      chapterBreakPoint = currentChapter?.data.videometa.choicebreakpoint;
      _initializeVideoPlayerFuture = null;
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('${currentChapter?.data.source}'),
      );
      _controller.addListener(videoListener);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.play();
      showChoices = false;
      showProceedButton = false;
    });
  }

  videoListener() {
    print(_controller.value.position);
    print(_controller.value.position + const Duration(microseconds: 1000) ==
        _controller.value.duration);
    print('${_controller.value.isCompleted} is completed');
    if (_controller.value.isCompleted) {
      print('show choices now');
      setState(() {
        if (chapterBreakPoint != null) {
          if (chapterBreakPoint!.choices.isNotEmpty) {
            showChoices = true;
          } else {
            showProceedButton = true;
          }
        }
      });
    }
  }

  @override
  void initState() {
    // setup the the lesson and current chapter related content
    setupLessonContent(widget.lessonId);
    // start with the first video
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('${currentChapter?.data.source}'),
    );

    _controller.addListener(videoListener);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _initializeVideoPlayerFuture = null;
    _controller?.pause()?.then((_) {
      _controller.dispose();
    });
    super.dispose();
  }

  final _nameStyle = const TextStyle(
    fontSize: 20,
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              AspectRatio(
                // key: Key(${currentChapter?.data.source}),
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (chapterIndex > 0)
                    FloatingActionButton(
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (chapterIndex > 0) {
                            chapterIndex -= 1;
                          }
                        });
                      },
                    ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    // Display the correct icon depending on the state of the player.
                    child: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $chapterName',
                    style: _nameStyle,
                  ),
                  Text(
                    'Description $chapterDesc',
                    style: _nameStyle,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              showChoices
                  ? Text(
                      '${chapterBreakPoint?.question}',
                      style: _nameStyle,
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              if (showChoices && chapterBreakPoint?.choices != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chapterBreakPoint!.choices.isNotEmpty)
                      for (var choice in chapterBreakPoint!.choices)
                        Material(
                          color: Colors.black,
                          child: RadioListTile(
                            title: Text(
                              choice.label,
                              style: _nameStyle,
                            ),
                            value: choice.value,
                            groupValue: selectedChoice,
                            onChanged: (value) {
                              setState(() {
                                selectedChoice = value!;
                                showProceedButton = true;
                              });
                            },
                          ),
                        ),
                  ],
                ),
              showProceedButton
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor:
                                MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white70;
                              } else {
                                return Colors.white60;
                              }
                            })),
                            onPressed:() => changeChapter(chapterIndex + 1),
                            child: Text(
                              'Procced',
                              style: _nameStyle,
                            ))
                      ],
                    )
                  : const SizedBox(
                      height: 10.0,
                    )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
