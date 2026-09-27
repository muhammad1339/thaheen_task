import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';

class CoursesState {
  const CoursesState({
    this.courses = const [],
    this.query = '',
    this.loading = false,
    this.failure,
  });
  final List<CourseEntity> courses;
  final String query;
  final bool loading;
  final Failure? failure;
  List<CourseEntity> get filtered {
    final q = query.trim().toLowerCase();
    return courses
        .where(
          (c) =>
              c.title.toLowerCase().contains(q) ||
              c.instructor.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  String toString() =>
      'CoursesState(courses: ${courses.length}, query: "$query", '
      'loading: $loading, failure: $failure)';
}

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this.repository) : super(const CoursesState());
  final CourseRepository repository;
  Future<void> load() async {
    emit(CoursesState(query: state.query, loading: true));
    final result = await repository.getCourses();
    if (isClosed) return;
    switch (result) {
      case Success<List<CourseEntity>>(:final value):
        emit(CoursesState(courses: value, query: state.query));
      case FailureResult<List<CourseEntity>>(:final failure):
        emit(CoursesState(query: state.query, failure: failure));
    }
  }

  void setQuery(String query) => emit(
    CoursesState(
      courses: state.courses,
      query: query,
      loading: state.loading,
      failure: state.failure,
    ),
  );
}
