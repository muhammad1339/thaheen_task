import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/courses/data/mapper/course_mapper.dart';
import 'package:thaheen_task/features/courses/data/model/course_catalog_serializable.dart';
import 'package:thaheen_task/utils/logger/app_logger.dart';

/// Repository that loads and caches course catalog data from bundled assets.
class AssetCourseRepository implements CourseRepository {
  AssetCourseRepository({Future<String> Function()? loadAsset})
    : _load =
          loadAsset ??
          (() => rootBundle.loadString('assets/data/courses.json'));

  final Future<String> Function() _load;

  /// Shared by concurrent callers; cleared on failure so a retry reloads.
  Future<Result<List<CourseEntity>>>? _courses;

  @override
  Future<Result<List<CourseEntity>>> getCourses() =>
      _courses ??= _loadCourses();

  Future<Result<List<CourseEntity>>> _loadCourses() async {
    final result = await _readCatalog();
    if (result is FailureResult) _courses = null;
    return result;
  }

  Future<Result<List<CourseEntity>>> _readCatalog() async {
    try {
      final json = jsonDecode(await _load());
      if (json is! Map<String, dynamic>) {
        throw const FormatException('Catalog root must be an object');
      }
      return Success(CourseCatalogSerializable.fromJson(json).toEntities());
    } catch (error, stackTrace) {
      AppLogger.e(
        'Failed to load courses catalog',
        tag: 'CourseRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return const FailureResult(Failure(FailureType.invalidData));
    }
  }

  @override
  Future<Result<CourseEntity>> getCourseById(String courseId) async {
    final result = await getCourses();
    return switch (result) {
      Success(:final value) => _findCourse(value, courseId),
      FailureResult(:final failure) => FailureResult(failure),
    };
  }

  Result<CourseEntity> _findCourse(
    List<CourseEntity> courses,
    String courseId,
  ) {
    for (final course in courses) {
      if (course.id == courseId) {
        return Success(course);
      }
    }
    return const FailureResult(Failure(FailureType.notFound));
  }
}
