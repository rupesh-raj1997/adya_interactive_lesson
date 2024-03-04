import 'package:adya_interactive_lesson/models/video.dart';
import 'package:flutter/material.dart';
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
  bool isLessonCompleted = false;
  Lesson? lesson;
  Chapter? currentChapter;
  int chapterIndex = 0;
  double _playbackTime = 0.0;
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
    print('changing to $chapterNumber');

    if (currentChapter?.children.length == 0) {
      setState(() {
        isLessonCompleted = true;
      });
      return;
    }
    Chapter? newChapter;
    if (currentChapter!.children.length > 1) {
      if (selectedChoice.isEmpty) {
        newChapter = currentChapter?.children.first;
      } else {
        newChapter = currentChapter?.children.firstWhere(
          (chapter) => selectedChoice.contains('${chapter.data.videometa.id}'),
        );
      }
    } else {
      newChapter = currentChapter?.children.first;
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
    double sliderValue = _controller.value.position.inSeconds.toDouble();
    if (chapterIndex == 1) {
      sliderValue += 14;
    } else if (chapterIndex == 2) {
      sliderValue += 22;
    } else if (chapterIndex == 3) {
      sliderValue += 47.5;
    }
    setState(() {
      _playbackTime = sliderValue;
    });
    print(_controller.value.position);
    print(_controller.value.position + const Duration(microseconds: 1000) ==
        _controller.value.duration);
    print('${_controller.value.isCompleted} is completed');
    if (_controller.value.isCompleted) {
      print('show choices now');
      setState(() {
        if (chapterBreakPoint != null) {
          if (chapterBreakPoint!.choices.isEmpty) {
            setState(() {
              showProceedButton = false;
              showChoices = false;
              chapterIndex += 1;
            });
            changeChapter(chapterIndex);
          } else {
            showChoices = true;
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
        if (isLessonCompleted) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Completed',
                    style: _nameStyle,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.green[300]!),
                    ),
                    onPressed: () {
                      setState(() {
                        chapterIndex = 0;
                        _playbackTime = 0.0;
                        isLessonCompleted = false;
                      });
                      setupLessonContent(widget.lessonId);
                      _controller = VideoPlayerController.networkUrl(
                        Uri.parse('${currentChapter?.data.source}'),
                      );

                      _controller.addListener(videoListener);
                      _initializeVideoPlayerFuture = _controller.initialize();
                    },
                    child: Text(
                      'Restart',
                      style: _nameStyle,
                    ),
                  )
                ],
              )
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Material(
                  child: Slider(
                    min: 0,
                    max: 67.5,
                    value: _playbackTime,
                    onChanged: (newVal) {
                      if (newVal > _playbackTime) {
                        return;
                      } else {
                        if (0 < newVal && newVal < 15) {
                          changeChapter(0);
                        } else if (0 <= newVal && newVal < 15) {
                          changeChapter(1);
                        } else if (15 <= newVal && newVal < 32.5) {
                          changeChapter(2);
                        } else if (32.5 <= newVal) {
                          changeChapter(3);
                        }
                      }
                      print('new val $newVal, $_playbackTime');
                    },
                    onChangeStart: (val) {
                      print('started dragging $val');
                      _controller.pause();
                    },
                    onChangeEnd: (_) => _controller.play(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                      ),
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green[300]!),
                            ),
                            onPressed: () {
                              setState(() {
                                chapterIndex += 1;
                              });
                              changeChapter(chapterIndex);
                            },
                            child: Text(
                              'Procced',
                              style: _nameStyle,
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
