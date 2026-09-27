import 'package:thaheen_task/features/courses/data/model/json_fields.dart';
import 'package:thaheen_task/features/courses/data/model/lesson_serializable.dart';

class SectionSerializable {
  const SectionSerializable({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory SectionSerializable.fromJson(Map<String, dynamic> json) =>
      SectionSerializable(
        id: json.requireString('id'),
        title: json.requireString('title'),
        lessons: json.requireList('lessons', LessonSerializable.fromJson),
      );

  final String id, title;
  final List<LessonSerializable> lessons;
}
