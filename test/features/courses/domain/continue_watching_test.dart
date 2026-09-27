import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_task/features/courses/domain/continue_watching.dart';

import '../../../helpers/test_courses.dart';

/// Unit tests for picking the "Continue watching" lesson: the first
/// unlocked, unfinished lesson in catalog order.
void main() {
  group('Continue watching', () {
    final courses = [
      testCourse('c1', [
        ['a', 'b'],
      ]),
      testCourse('c2', [
        ['x', 'y'],
      ]),
    ];

    test('picks the first unlocked, unfinished lesson in catalog order', () {
      // "a" is done, so "b" (course 1) comes before "x" (course 2).
      final result = findContinueWatching(
        courses: courses,
        progressByLessonId: {
          'a': startedLesson('a', completed: true),
          'b': startedLesson('b'),
          'x': startedLesson('x'),
        },
        completedLessonIds: {'a'},
      );

      expect(result?.$1.id, 'c1');
      expect(result?.$2.id, 'b');
    });

    test('skips a started lesson that is still locked', () {
      // "b" has progress, but "a" is not completed, so "b" is locked.
      final result = findContinueWatching(
        courses: courses,
        progressByLessonId: {'b': startedLesson('b')},
        completedLessonIds: const {},
      );

      expect(result, isNull);
    });

    test('returns nothing when no lesson is unfinished', () {
      final result = findContinueWatching(
        courses: courses,
        progressByLessonId: {'a': startedLesson('a', completed: true)},
        completedLessonIds: {'a'},
      );

      expect(result, isNull);
    });
  });
}
