import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';

class PlayerState {
  const PlayerState({
    this.course,
    this.lesson,
    this.loading = false,
    this.locked = false,
    this.failure,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.playing = false,
    this.speed = 1,
    this.nextLessonId,
    this.nextUnlocked = false,
    this.saveFailed = false,
  });
  final CourseEntity? course;
  final LessonEntity? lesson;
  final bool loading, locked, playing, nextUnlocked, saveFailed;
  final Failure? failure;
  final Duration position, duration;
  final double speed;
  final String? nextLessonId;

  @override
  String toString() =>
      'PlayerState(lesson: ${lesson?.id}, loading: $loading, locked: $locked, '
      'playing: $playing, position: $position / $duration, speed: $speed, '
      'next: $nextLessonId (unlocked: $nextUnlocked), '
      'saveFailed: $saveFailed, failure: $failure)';
}
