import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';

abstract interface class CourseRepository {
  Future<Result<List<CourseEntity>>> getCourses();
  Future<Result<CourseEntity>> getCourseById(String courseId);
}
