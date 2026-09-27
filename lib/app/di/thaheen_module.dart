import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:thaheen_task/core/domain/errors/exceptions.dart';

import 'package:thaheen_task/features/courses/data/repository/asset_course_repository.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/notes/data/repository/hive_lesson_notes_repository.dart';
import 'package:thaheen_task/features/notes/domain/repository/lesson_notes_repository.dart';
import 'package:thaheen_task/features/progress/data/repository/hive_progress_repository.dart';
import 'package:thaheen_task/features/progress/domain/repository/progress_repository.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/settings/data/repository/hive_app_settings_repository.dart';
import 'package:thaheen_task/features/settings/domain/repository/app_settings_repository.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';

/// Composition root: the only place that knows about GetIt. Everything else
/// receives its dependencies through constructors.
class ThaheenModule {
  ThaheenModule(this.box);
  final Box<dynamic> box;
  final GetIt _scope = GetIt.asNewInstance();

  CourseRepository get courses => _scope();
  LessonNotesRepository get notes => _scope();
  AppSettingsCubit get settings => _scope();
  ProgressCubit get progress => _scope();

  Future<void> initialize() async {
    _scope
      ..registerSingleton<CourseRepository>(AssetCourseRepository())
      ..registerSingleton<LessonNotesRepository>(HiveLessonNotesRepository(box))
      ..registerSingleton<AppSettingsRepository>(HiveAppSettingsRepository(box))
      ..registerSingleton<ProgressRepository>(HiveProgressRepository(box))
      ..registerSingleton(AppSettingsCubit(_scope()))
      ..registerSingleton(ProgressCubit(_scope()));
    await settings.load();
    await progress.load();
    if (settings.state.failure != null) {
      await dispose();
      throw const ThaheenStartupException('Could not load settings');
    }
  }

  Future<void> dispose() async {
    await settings.close();
    await progress.close();
    await _scope.reset();
  }

  static Future<ThaheenModule> open() async {
    final Box<dynamic> box;
    try {
      await Hive.initFlutter();
      box = await Hive.openBox<dynamic>('thaheen');
    } catch (error) {
      throw ThaheenStartupException('Could not open storage', cause: error);
    }
    final module = ThaheenModule(box);
    try {
      await module.initialize();
      return module;
    } catch (_) {
      await box.close();
      rethrow;
    }
  }
}
