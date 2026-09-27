import 'package:thaheen_task/features/courses/domain/entity/lesson_entity.dart';

class SectionEntity {
  SectionEntity({
    required this.id,
    required this.title,
    required List<LessonEntity> lessons,
  }) : lessons = List.unmodifiable(lessons);
  final String id, title;
  final List<LessonEntity> lessons;
}
