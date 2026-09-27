import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';

import '../../../helpers/test_courses.dart';

/// Unit tests for the pure progress rules. The first three groups are the
/// task's required tests; "Unfinished lesson" backs Continue watching.
void main() {
  group('Completion (90% rule)', () {
    bool completes(int watchedMs, {int durationMs = 1000}) {
      return ProgressRules.shouldComplete(
        position: Duration(milliseconds: watchedMs),
        duration: Duration(milliseconds: durationMs),
      );
    }

    test('89.9% watched is not complete', () {
      expect(completes(899), isFalse);
    });

    test('exactly 90% watched is complete', () {
      expect(completes(900), isTrue);
    });

    test('more than 90% watched is complete', () {
      expect(completes(950), isTrue);
    });

    test('a zero-length video never completes', () {
      expect(completes(1000, durationMs: 0), isFalse);
    });

    test('a negative position never completes', () {
      expect(completes(-1000), isFalse);
    });
  });

  group('Sequential unlock', () {
    // Lessons unlock in order across sections: s1-a → s1-b → s2-a → s2-b.
    final course = testCourse('course', [
      ['s1-a', 's1-b'],
      ['s2-a', 's2-b'],
    ]);

    bool isUnlocked(String lessonId, {Set<String> completed = const {}}) {
      return ProgressRules.isLessonUnlocked(
        lessonId: lessonId,
        orderedLessonIds: course.lessonIds,
        completedLessonIds: completed,
      );
    }

    test('the first lesson is always unlocked', () {
      expect(isUnlocked('s1-a'), isTrue);
    });

    test(
      'the second lesson is locked while the previous one is incomplete',
      () {
        expect(isUnlocked('s1-b'), isFalse);
      },
    );

    test('the second lesson unlocks once the previous one is complete', () {
      expect(isUnlocked('s1-b', completed: {'s1-a'}), isTrue);
    });

    test('the next section stays locked until the previous section ends', () {
      expect(isUnlocked('s2-a', completed: {'s1-a'}), isFalse);
    });

    test('the next section unlocks once the previous section is complete', () {
      expect(isUnlocked('s2-a', completed: {'s1-a', 's1-b'}), isTrue);
    });

    test('a lesson that is not in the course is locked', () {
      expect(isUnlocked('missing', completed: {'s1-a', 's1-b'}), isFalse);
    });
  });

  group('Course progress', () {
    double progress(int completed, int total) {
      return ProgressRules.calculateCourseProgress(
        completedLessons: completed,
        totalLessons: total,
      );
    }

    test('nothing completed is 0', () {
      expect(progress(0, 4), 0.0);
    });

    test('partial completion is the completed fraction', () {
      expect(progress(1, 4), 0.25);
    });

    test('everything completed is 1', () {
      expect(progress(4, 4), 1.0);
    });

    test('an empty course is 0, not a division by zero', () {
      expect(progress(0, 0), 0.0);
    });

    test('out-of-range counts are clamped between 0 and 1', () {
      expect(progress(-1, 4), 0.0);
      expect(progress(5, 4), 1.0);
    });
  });

  group('Unfinished lesson', () {
    test('a lesson with no progress is not unfinished', () {
      expect(ProgressRules.isUnfinished(null), isFalse);
    });

    test('a lesson at position zero is not unfinished', () {
      const notStarted = LessonProgressEntity(lessonId: 'a');
      expect(ProgressRules.isUnfinished(notStarted), isFalse);
    });

    test('a started, incomplete lesson is unfinished', () {
      expect(ProgressRules.isUnfinished(startedLesson('a')), isTrue);
    });

    test('a completed lesson is not unfinished', () {
      final completed = startedLesson('a', completed: true);
      expect(ProgressRules.isUnfinished(completed), isFalse);
    });
  });
}
