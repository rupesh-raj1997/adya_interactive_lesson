part of 'lesson_bloc.dart';

class LessonState {
  final Lesson lesson;
  final VideoPlayerController controller;
  final bool isLessonLoaded;
  final bool isCurrChapterDone;
  final List<Chapter> completedChapters;
  final double currentProgress;
  final Chapter currentChapter;
  final Map<Chapter, Choice> selectedChoices;

  LessonState._(
      {required this.lesson,
      required this.controller,
      required this.isLessonLoaded,
      required this.completedChapters,
      required this.selectedChoices,
      required this.currentChapter,
      required this.currentProgress,
      required this.isCurrChapterDone});

  factory LessonState.usingLesson({required Lesson lesson}) {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(lesson.lessonStart.videoURL),
    );
    return LessonState._(
      lesson: lesson,
      isLessonLoaded: false,
      isCurrChapterDone: false,
      currentProgress: 0.0,
      controller: controller,
      selectedChoices: const {},
      completedChapters: const [],
      currentChapter: lesson.lessonStart,
    );
  }

  Future<void> dispose() async {
    controller.dispose();
  }

  LessonState copyWith({
    Lesson? lesson,
    VideoPlayerController? controller,
    bool? isLessonLoaded,
    bool? isCurrChapterDone,
    List<Chapter>? completedChapters,
    Map<Chapter, Choice>? selectedChoices,
    Chapter? currentChapter,
    double? currentProgress,
  }) {
    return LessonState._(
      lesson: lesson ?? this.lesson,
      controller: controller ?? this.controller,
      isLessonLoaded: isLessonLoaded ?? this.isLessonLoaded,
      completedChapters: completedChapters ?? this.completedChapters,
      selectedChoices: selectedChoices ?? this.selectedChoices,
      currentChapter: currentChapter ?? this.currentChapter,
      currentProgress: currentProgress ?? this.currentProgress,
      isCurrChapterDone: isCurrChapterDone ?? this.isCurrChapterDone,
    );
  }

  bool get notLoaded => !isLessonLoaded;
  bool get isPlaying => controller.value.isPlaying;
  bool get isInitialized => controller.value.isInitialized;
  double get lessonDuration {
    List<double> sums = pathSum(findAllPaths(lesson.lessonStart));
    return sums.reduce((value, element) => value + element) / sums.length;
  }

  @override
  String toString() {
    return 'state lessonDuration is $lessonDuration controller is $controller';
  }
}
