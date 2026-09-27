import 'package:thaheen_task/features/courses/data/model/course_serializable.dart';
import 'package:thaheen_task/features/courses/data/model/json_fields.dart';

/// The whole catalog file: `{ "courses": [...] }`.
///
/// Besides field validation, `fromJson` requires course and lesson IDs to be
/// unique across the catalog. Lesson IDs matter most: progress and notes are
/// stored by lesson ID alone, so a repeat would mix two lessons' data.
/// Throws [FormatException] on any violation.
class CourseCatalogSerializable {
  const CourseCatalogSerializable({required this.courses});

  factory CourseCatalogSerializable.fromJson(Map<String, dynamic> json) {
    final catalog = CourseCatalogSerializable(
      courses: json.requireList('courses', CourseSerializable.fromJson),
    );
    catalog._checkUniqueIds();
    return catalog;
  }

  final List<CourseSerializable> courses;

  void _checkUniqueIds() {
    _checkUnique(courses.map((course) => course.id), 'course');
    _checkUnique([
      for (final course in courses)
        for (final section in course.sections)
          for (final lesson in section.lessons) lesson.id,
    ], 'lesson');
  }

  static void _checkUnique(Iterable<String> ids, String kind) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) throw FormatException('Duplicate $kind id "$id"');
    }
  }
}
