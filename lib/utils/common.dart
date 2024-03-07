import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

List<double> pathSum(List<List> data) {
  List<double> sums = [];
  for (var sublist in data) {
    double sum = sublist.reduce((value, element) => value + element);
    sums.add(sum);
  }
  return sums;
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

int findHeight(Chapter root) {
  if (root.children.isEmpty) {
    return 1;
  }
  int maxHeight = 0;
  for (var child in root.children) {
    if (findHeight(child) > maxHeight) {
      maxHeight = findHeight(child);
    }
  }
  return 1 + maxHeight;
}

void restart(BuildContext context) {
  Phoenix.rebirth(context);
}
