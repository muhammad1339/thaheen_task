import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';

/// Picks the lesson for the "Continue watching" card.
///
/// Progress has no timestamps, so the rule is deterministic by catalog order:
/// the first unlocked, unfinished lesson of the first course that has one.
(CourseEntity, LessonEntity)? findContinueWatching({
  required List<CourseEntity> courses,
  required Map<String, LessonProgressEntity> progressByLessonId,
  required Set<String> completedLessonIds,
}) {
  for (final course in courses) {
    for (final (index, lesson) in course.lessons.indexed) {
      final unlocked = ProgressRules.isUnlocked(
        lessonIndex: index,
        orderedLessonIds: course.lessonIds,
        completedLessonIds: completedLessonIds,
      );
      if (unlocked &&
          ProgressRules.isUnfinished(progressByLessonId[lesson.id])) {
        return (course, lesson);
      }
    }
  }
  return null;
}
