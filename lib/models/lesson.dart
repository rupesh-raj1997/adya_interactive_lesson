import 'package:adya_interactive_lesson/models/video.dart';

// A Lesson is an abstraction for interactive video
// Lesson is of tree data type and it is composed of Chapters

class Chapter {
  VideoLesson data;
  List<Chapter> children;

  Chapter(this.data) : children = [];

  void addChild(Chapter node) {
    children.add(node);
  }
}

class Lesson {
  late Chapter lessonStart;

  Lesson(VideoLesson videoLesson) {
    lessonStart = Chapter(videoLesson);
  }

  void addChapter(Chapter parentChapter, Chapter newChapter) {
    Chapter? parent = _findNode(lessonStart, parentChapter.data);
    if (parent != null) {
      parent.addChild(newChapter);
    } else {
      throw Exception("Parent chapter not found");
    }
  }

  Chapter? _findNode(Chapter node, VideoLesson data) {
    if (node.data == data) return node;
    Chapter? result;
    for (var child in node.children) {
      result = _findNode(child, data);
      if (result != null) {
        break;
      }
    }
    return result;
  }

  printLesson(Chapter? start) {
    if (start == null) return;

    if (start.children.isNotEmpty) {
      for (var chap in start.children) {
        printLesson(chap);
        print('${chap.data.videometa.name} ${chap.data.source} ');
      }
    }
  }
}
