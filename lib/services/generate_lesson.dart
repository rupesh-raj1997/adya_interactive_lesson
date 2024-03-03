import 'package:adya_interactive_lesson/constants/static.dart';
import 'package:adya_interactive_lesson/models/lesson.dart';
import 'package:adya_interactive_lesson/models/video.dart';

String chapter001 = '$CLOUDFRONT_URL/start_discuss_1.mp4'; // done
String chapter011 = '$CLOUDFRONT_URL/female_plan_11.mp4'; // done
String chapter012 = '$CLOUDFRONT_URL/male_plan_12.mp4';
String chapter111 = '$CLOUDFRONT_URL/female_implement_111.mp4'; // done
String chapter121 = '$CLOUDFRONT_URL/male_implement_121.mp4';
String chapter122 = '$CLOUDFRONT_URL/male_implement_122.mp4';
String chapter003 = '$CLOUDFRONT_URL/project_complete.mp4'; // done

VideoLesson chapter001Video = VideoLesson(
  source: chapter001,
  videometa: VideoMetaData(
    id: 1,
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

VideoLesson chapter011Video = VideoLesson(
  source: chapter011,
  videometa: VideoMetaData(
    id: 1,
    name: 'Ms Lorem plan',
    description: 'Lorem explains her plan',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets start implementaion!', choices: []),
  ),
);

VideoLesson chapter111Video = VideoLesson(
  source: chapter111,
  videometa: VideoMetaData(
    id: 1,
    name: 'Ms Lorem implementation',
    description: 'Lorem implemets her plan to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);

VideoLesson chapter003Video = VideoLesson(
  source: chapter003,
  videometa: VideoMetaData(
    id: 1,
    name: 'Project complete',
    description: 'We have completed the project',
    choicebreakpoint: ChoiceBreakPoint(question: 'Restart?', choices: []),
  ),
);

VideoLesson chapter012Video = VideoLesson(
  source: chapter012,
  videometa: VideoMetaData(
    id: 1,
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

VideoLesson chapter121Video = VideoLesson(
  source: chapter121,
  videometa: VideoMetaData(
    id: 1,
    name: 'Mr. Ipsum implementation',
    description: 'Ipsum implements his plan 1 using approach 1 to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);

VideoLesson chapter122Video = VideoLesson(
  source: chapter122,
  videometa: VideoMetaData(
    id: 1,
    name: 'Mr. Ipsum implementation',
    description: 'Ipsum implements his plan 2 using approach 2 to completion',
    choicebreakpoint:
        ChoiceBreakPoint(question: 'Lets shake hands!', choices: []),
  ),
);


Lesson fetchLesson(int id) {
  
  Lesson lesson = Lesson(chapter001Video);

  Chapter femaleChap =  Chapter(chapter011Video);
  Chapter femlateImplement = Chapter(chapter111Video);

  Chapter maleChap =  Chapter(chapter012Video);
  Chapter maleImplement1 = Chapter(chapter121Video);
  Chapter maleImplement2 = Chapter(chapter122Video);

  Chapter close = Chapter(chapter003Video);

  lesson.addChapter(lesson.lessonStart,femaleChap);
  lesson.addChapter(lesson.lessonStart, maleChap);
  lesson.addChapter(femaleChap, femlateImplement);
  lesson.addChapter(maleChap, maleImplement1);
  lesson.addChapter(maleChap, maleImplement2);

  return lesson;
}
