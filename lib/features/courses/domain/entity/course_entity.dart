import 'package:thaheen_task/features/courses/domain/entity/section_entity.dart';
import 'package:thaheen_task/features/courses/domain/entity/lesson_entity.dart';
export 'package:thaheen_task/features/courses/domain/entity/section_entity.dart';
export 'package:thaheen_task/features/courses/domain/entity/lesson_entity.dart';

class CourseEntity {
  CourseEntity({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required List<SectionEntity> sections,
  }) : sections = List.unmodifiable(sections);
  final String id, title, instructor, thumbnail;
  final List<SectionEntity> sections;

  /// All lessons in playback order, flattened across sections.
  late final List<LessonEntity> lessons = List.unmodifiable([
    for (final section in sections) ...section.lessons,
  ]);

  /// [lessons]' IDs in the same order; the sequence unlocking follows.
  late final List<String> lessonIds = List.unmodifiable([
    for (final lesson in lessons) lesson.id,
  ]);
}
