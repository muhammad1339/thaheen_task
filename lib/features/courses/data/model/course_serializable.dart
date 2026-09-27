import 'package:thaheen_task/features/courses/data/model/json_fields.dart';
import 'package:thaheen_task/features/courses/data/model/section_serializable.dart';

class CourseSerializable {
  const CourseSerializable({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.sections,
  });

  factory CourseSerializable.fromJson(Map<String, dynamic> json) =>
      CourseSerializable(
        id: json.requireString('id'),
        title: json.requireString('title'),
        instructor: json.requireString('instructor'),
        thumbnail: json.requireString('thumbnail'),
        sections: json.requireList('sections', SectionSerializable.fromJson),
      );

  final String id, title, instructor, thumbnail;
  final List<SectionSerializable> sections;
}
