class Choice {
  // late int id;
  late String label;
  late String value;
  Choice({
    // required this.id,
    required this.label,
    required this.value,
  });
}

class ChoiceBreakPoint {
  int? time;
  late String question;
  List<Choice> choices = [];
  ChoiceBreakPoint({
    this.time,
    required this.question,
    required this.choices,
  });
}

class ChapterVideo {
  late String source;
  late ChapterMeta videometa;
  ChapterVideo({
    required this.source,
    required this.videometa,
  });

  
}

class ChapterMeta {
  late int id;
  late double duration;
  String? name = '';
  String? description = '';
  ChoiceBreakPoint? choicebreakpoint;

  ChapterMeta({
    required this.id,
    required this.duration,
    this.name,
    this.description,
    this.choicebreakpoint,
  });
}
