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

class VideoLesson {
  late String source;
  late VideoMetaData videometa;
  VideoLesson({
    required this.source,
    required this.videometa,
  });
}

class VideoMetaData {
  late int id;
  String? name = '';
  String? description = '';
  ChoiceBreakPoint? choicebreakpoint;

  VideoMetaData({
    required this.id,
    this.name,
    this.description,
    this.choicebreakpoint,
  });
}