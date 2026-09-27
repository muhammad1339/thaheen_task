import 'package:thaheen_task/features/courses/data/model/course_catalog_serializable.dart';
import 'package:thaheen_task/features/courses/data/model/course_serializable.dart';
import 'package:thaheen_task/features/courses/data/model/lesson_serializable.dart';
import 'package:thaheen_task/features/courses/data/model/section_serializable.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';

extension CourseCatalogMapper on CourseCatalogSerializable {
  List<CourseEntity> toEntities() =>
      List.unmodifiable([for (final course in courses) course.toEntity()]);
}

extension CourseMapper on CourseSerializable {
  CourseEntity toEntity() => CourseEntity(
    id: id,
    title: title,
    instructor: instructor,
    thumbnail: thumbnail,
    sections: [for (final section in sections) section.toEntity()],
  );
}

extension SectionMapper on SectionSerializable {
  SectionEntity toEntity() => SectionEntity(
    id: id,
    title: title,
    lessons: [for (final lesson in lessons) lesson.toEntity()],
  );
}

extension LessonMapper on LessonSerializable {
  LessonEntity toEntity() => LessonEntity(
    id: id,
    title: title,
    videoAsset: video,
    duration: Duration(seconds: durationSec),
  );
}
