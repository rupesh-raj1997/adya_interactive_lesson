import 'package:adya_interactive_lesson/constants/static.dart';
import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';

String s3ResourceURL(String resourceName) {
  return '$CLOUDFRONT_URL/$resourceName';
}

ChapterVideo chapter001Video = ChapterVideo(
  source: s3ResourceURL('start_discuss_1.mp4'),
  videometa: ChapterMeta(
    id: 1,
    duration: 14.0,
    name: 'Lesson Start',
    description: 'Start of Lesson',
    choicebreakpoint: ChoiceBreakPoint(
      question: 'Who should lead the Project?',
      choices: [
        Choice(
          label: 'Ms. Lorem',
          value: 'employee_1',
        ),
        Choice(
          label: 'Mr. Ipsum',
          value: 'employee_2',
        ),
      ],
    ),
  ),
);

ChapterVideo chapter011Video = ChapterVideo(
  source: s3ResourceURL('female_plan_11.mp4'),
  videometa: ChapterMeta(
    id: 1,
    duration: 19.0,
    name: 'Ms Lorem plan',
    description: 'Lorem explains her plan',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets start implementaion!', choices: []),
  ),
);

ChapterVideo chapter111Video = ChapterVideo(
  source: s3ResourceURL('female_implement_111.mp4'),
  videometa: ChapterMeta(
    id: 1,
    duration: 12.0 ,
    name: 'Ms Lorem implementation',
    description: 'Lorem implemets her plan to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);

ChapterVideo chapter003Video = ChapterVideo(
  source: s3ResourceURL('project_complete.mp4'),
  videometa: ChapterMeta(
    id: 1,
    duration: 20.0,
    name: 'Project complete',
    description: 'We have completed the project',
    choicebreakpoint: ChoiceBreakPoint(question: 'Restart?', choices: []),
  ),
);

ChapterVideo chapter012Video = ChapterVideo(
  source: s3ResourceURL('male_plan_12.mp4'),
  videometa: ChapterMeta(
    id: 2,
    duration: 18.0,
    name: 'Mr. Ipsum plan',
    description: 'Ipsum explains his plan',
    choicebreakpoint: ChoiceBreakPoint(
        question: 'Which implementation will you prefer?',
        choices: [
          Choice(
            label: 'We can head with normal dfs approach',
            value: 'approach_1',
          ),
          Choice(
            label: 'We can head with an iterative approach',
            value: 'approach_2',
          ),
        ]),
  ),
);

ChapterVideo chapter121Video = ChapterVideo(
  source: s3ResourceURL('male_implement_121.mp4'),
  videometa: ChapterMeta(
    id: 1,
    duration: 21.0,
    name: 'Mr. Ipsum implementation',
    description: 'Ipsum implements his plan 1 using approach 1 to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);

ChapterVideo chapter122Video = ChapterVideo(
  source: s3ResourceURL('male_implement_122.mp4'),
  videometa: ChapterMeta(
    id: 2,
    duration: 14.0,
    name: 'Mr. Ipsum implementation',
    description: 'Ipsum implements his plan 2 using approach 2 to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);

Lesson loadLesson() {
  final Lesson lesson = Lesson(chapter001Video);

  Chapter femaleChap = Chapter(chapter011Video);
  Chapter femlateImplement = Chapter(chapter111Video);

  Chapter maleChap = Chapter(chapter012Video);
  Chapter maleImplement1 = Chapter(chapter121Video);
  Chapter maleImplement2 = Chapter(chapter122Video);

  Chapter close = Chapter(chapter003Video);

  lesson.addChapter(lesson.lessonStart, femaleChap);
  lesson.addChapter(lesson.lessonStart, maleChap);

  lesson.addChapter(femaleChap, femlateImplement);
  lesson.addChapter(femlateImplement, close);

  lesson.addChapter(maleChap, maleImplement1);
  lesson.addChapter(maleChap, maleImplement2);
  lesson.addChapter(maleImplement1, close);
  lesson.addChapter(maleImplement2, close);
  return lesson;
}
