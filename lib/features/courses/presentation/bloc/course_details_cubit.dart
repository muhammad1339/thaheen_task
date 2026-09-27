import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';

class CourseDetailsState {
  const CourseDetailsState({this.course, this.loading = false, this.failure});
  final CourseEntity? course;
  final bool loading;
  final Failure? failure;

  @override
  String toString() =>
      'CourseDetailsState(course: ${course?.id}, loading: $loading, '
      'failure: $failure)';
}

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit(this.repository) : super(const CourseDetailsState());
  final CourseRepository repository;
  Future<void> load(String id) async {
    emit(const CourseDetailsState(loading: true));
    final result = await repository.getCourseById(id);
    if (isClosed) return;
    switch (result) {
      case Success<CourseEntity>(:final value):
        emit(CourseDetailsState(course: value));
      case FailureResult<CourseEntity>(:final failure):
        emit(CourseDetailsState(failure: failure));
    }
  }
}
