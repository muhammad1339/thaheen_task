import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_task/core/design_system/theme/thaheen_theme.dart';
import 'package:thaheen_task/features/courses/data/repository/asset_course_repository.dart';
import 'package:thaheen_task/features/courses/presentation/screen/course_details_screen.dart';
import 'package:thaheen_task/features/courses/presentation/screen/courses_screen.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

import '../../../helpers/in_memory_progress_repository.dart';
import '../../../helpers/test_courses.dart';

/// Widget tests for the course list and course details screens, in Arabic
/// (the app's default), using the real bundled catalog unless noted.
void main() {
  final l = lookupAppLocalizations(const Locale('ar'));
  final bundledCatalog = File('assets/data/courses.json').readAsStringSync();

  /// Shows [screen] inside a minimal Arabic app with the given progress.
  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    List<LessonProgressEntity> progress = const [],
  }) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      // The provider creates the shared progress cubit and closes it when
      // the test tears the widget tree down.
      BlocProvider(
        create: (_) =>
            ProgressCubit(InMemoryProgressRepository(progress))..load(),
        child: MaterialApp(
          theme: ThaheenTheme.light,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  AssetCourseRepository catalog(String json) =>
      AssetCourseRepository(loadAsset: () async => json);

  testWidgets('course list shows each course and a Continue watching card', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      CoursesScreen(repository: catalog(bundledCatalog)),
      progress: [startedLesson('l1')],
    );

    expect(find.text(l.continueWatching), findsOneWidget);
    expect(find.text('مقدمة في التشريح'), findsWidgets);
    expect(find.text('أساسيات وظائف الأعضاء'), findsOneWidget);
    expect(find.text(l.lessonsCount(4)), findsNWidgets(2));
    expect(find.text(l.percentage(0)), findsNWidgets(2));
  });

  testWidgets('tapping a locked lesson shows a friendly message', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      CourseDetailsScreen(
        repository: catalog(bundledCatalog),
        courseId: 'anatomy-101',
      ),
    );

    // Nothing completed yet, so every lesson after the first is locked.
    await tester.tap(find.byIcon(Icons.lock_outline).first);
    await tester.pump();

    expect(find.text(l.lockedMessage), findsOneWidget);
  });

  testWidgets('a course with no lessons shows an empty message', (
    tester,
  ) async {
    const emptyCourseCatalog = '''
{ "courses": [ {
  "id": "empty", "title": "Empty", "instructor": "Instructor",
  "thumbnail": "assets/images/anatomy.png", "sections": []
} ] }''';

    await pumpScreen(
      tester,
      CourseDetailsScreen(
        repository: catalog(emptyCourseCatalog),
        courseId: 'empty',
      ),
    );

    expect(find.text(l.emptyCourse), findsOneWidget);
  });
}
