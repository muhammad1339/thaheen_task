import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';

/// A course whose [sections] are given as lists of lesson IDs, e.g.
/// `testCourse('c1', [['a', 'b'], ['c']])` → two sections, three lessons.
CourseEntity testCourse(String id, List<List<String>> sections) {
  return CourseEntity(
    id: id,
    title: id,
    instructor: 'Instructor',
    thumbnail: 'thumbnail.png',
    sections: [
      for (final (index, lessonIds) in sections.indexed)
        SectionEntity(
          id: '$id-section-$index',
          title: 'Section $index',
          lessons: [
            for (final lessonId in lessonIds)
              LessonEntity(
                id: lessonId,
                title: lessonId,
                videoAsset: 'video.mp4',
                duration: const Duration(minutes: 1),
              ),
          ],
        ),
    ],
  );
}

/// Progress for a lesson the learner has started watching.
LessonProgressEntity startedLesson(String lessonId, {bool completed = false}) {
  return LessonProgressEntity(
    lessonId: lessonId,
    position: const Duration(seconds: 5),
    isCompleted: completed,
  );
}
